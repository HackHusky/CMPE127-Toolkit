`timescale 1ns / 1ps
`default_nettype none

`define SCAN_CODE_LENGTH 11
`define SCAN_CODE_DATA_LENGTH 8
`define RGB_RESOLUTION  		 4
`define FREQ_IN 32'd100_000_000

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/11/2018 05:02:44 PM
// Design Name:
// Module Name: VGA
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module ASCII_Keyboard(
    input wire clk,
    input wire rst,
    input wire ps2_clk,
    input wire ps2_data,
    input wire oe,
    input wire next,
    output wire [7:0] ascii,
    output wire ready,
    output wire underflow
);

wire [7:0] fifo_ascii;
wire [7:0] translated_to_ascii;
wire full, empty;
wire [7:0] scan_code; 
wire key_ready;

assign ascii = (oe) ? fifo_ascii : 8'hZ;
assign ready = (!empty);

Keyboard keyboard(
    .clk(clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .data(scan_code),
    .cs(1),
    .clr(clr),
    .ready(key_ready)
);

FIFO #(
    .LENGTH(16),
    .WIDTH(8)
) ascii_to_vga (
    .clk(clk),
    .rst(rst),
    .wr_cs(fifo_control),
    .wr_en(fifo_control),
    .rd_cs(next),
    .rd_en(next),
    .full(full),
    .overflow(),
    .empty(empty),
    .underflow(underflow),
    .out(fifo_ascii),
    .in(translated_to_ascii)
);

KeyboardToASCIIROM rom(
    .scan_code(scan_code_reg),
    .ascii(translated_to_ascii)
);

parameter WAITING = 0;
parameter NEW_CODE = 1;
parameter TRANSLATE = 2;
parameter WRITE_TO_FIFO = 3;
parameter STATE_WIDTH = $clog2(WRITE_TO_FIFO+1);

reg [11:0] address;
reg [STATE_WIDTH-1:0] state;
reg [7:0] scan_code_reg;
reg clr;
reg break_code_detected;
reg empty_reg;
reg previously_empty;
reg fifo_control;

// ==================================
//// Behavioral Block
// ==================================
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state = WAITING;
        clr = 0;
        fifo_control = 0;
        address = 0;
        scan_code_reg = 0;
        break_code_detected = 0;
    end
    else
    begin
        case(state)
            WAITING: begin
                clr          = 0;
                fifo_control = 0;
                if(key_ready)
                begin
                    scan_code_reg = scan_code;
                    state = NEW_CODE;
                end
            end
            NEW_CODE: begin
                fifo_control = 0;
                clr          = 1;
                if(break_code_detected)
                begin
                    break_code_detected = 0;
                    state = WAITING;
                end
                else begin
                    state = TRANSLATE;
                end
            end
            TRANSLATE: begin
                fifo_control = 0;
                clr          = 0;
                if(scan_code_reg == 8'hF0)
                begin
                    break_code_detected = 1;
                    state = WAITING;
                end
                else begin
                    state = WRITE_TO_FIFO;
                end
            end
            WRITE_TO_FIFO: begin
                fifo_control = 1;
                clr          = 0;
                state = WAITING;
            end
            default: begin
                fifo_control = 0;
                clr = 1;
                state = WAITING;
            end
        endcase
    end
end

endmodule

module Keyboard(
    //// input 100 MHz clock
    input wire clk,
    input wire rst,
    //// ps2 
    input wire ps2_clk,
    input wire ps2_data,
    //// chip select for Keyboard module
    input wire cs,
    //// signal to clear previous key
    input wire clr,
    //// 8-bit data input bus 
    output wire [`SCAN_CODE_DATA_LENGTH-1:0] data,
    //// busy signal to tell CPU or other hardware that the VGA controller cannot be writen to.
    output wire ready
);

wire new_code;
wire ps2_clk_sync;
wire ps2_data_sync;
wire count_finished;
wire internal_clear;
wire [3:0] count_output;
wire [`SCAN_CODE_LENGTH-1:0] scan_code;
wire calculated_parity;
wire is_valid_scan_code;
wire scancode_based_clear;
wire ready;

// assign internal_clear = (rst | clr  | scancode_based_clear);
assign internal_clear = (rst | clr);
// assign scancode_based_clear = (new_code && (scan_code[9:2] == 8'hF0 || scan_code[9:2] == 8'hE0));
assign count_finished = (count_output == `SCAN_CODE_LENGTH);
// assign ready = (new_code && scan_code[9:2] != 8'hF0 && scan_code[9:2] != 8'hE0);
assign ready = new_code;

Syncronizer #(.WIDTH(1)) sync_clk (
	.clk(clk),
	.rst(rst),
	.en(!ready),
	.in(ps2_clk),
	.sync_out(ps2_clk_sync)
);

Syncronizer #(.WIDTH(1)) sync_data (
	.clk(clk),
	.rst(rst),
	.en(!ready),
	.in(ps2_data),
	.sync_out(ps2_data_sync)
);

SHIFTREGISTER #(.WIDTH(`SCAN_CODE_LENGTH)) scan_code_register (
	.rst(internal_clear),
	.clk(!ps2_clk_sync),
	.en(!ready),
	.in(ps2_data_sync),
	.Q({
        scan_code[0],
        scan_code[1],
        scan_code[2],
        scan_code[3],
        scan_code[4],
        scan_code[5],
        scan_code[6],
        scan_code[7],
        scan_code[8],
        scan_code[9],
        scan_code[10]
    })
);

COUNTER #(.WIDTH(4)) counter_ps2_clks (
	.rst(internal_clear),
	.clk(!ps2_clk_sync),
	.load(0),
	.increment(1),
	.enable(!count_finished),
	.D(0),
	.Q(count_output)
);

XNOR #(.WIDTH(8)) parity_checker (
	.in(scan_code[8:1]),
	.out(calculated_parity)
);

XNOR #(.WIDTH(2)) parity_matcher (
	.in({ scan_code[9], calculated_parity} ),
	.out(is_valid_scan_code)
);

AND #(.WIDTH(2)) new_signal (
    .in({ is_valid_scan_code, count_finished }),
    .out(new_code)
);

TRIBUFFER #(.WIDTH(8)) scan_code_buffer (
	.oe(cs),
	.in(scan_code[8:1]),
	.out(data)
);

endmodule

module KeyboardToASCIIROM(
    input wire [7:0] scan_code,
    output reg [7:0] ascii
);

always @(scan_code) begin
    case (scan_code)
        8'h1C: ascii = "A";
        8'h32: ascii = "B";
        8'h21: ascii = "C";
        8'h23: ascii = "D";
        8'h24: ascii = "E";
        8'h2B: ascii = "F";
        8'h34: ascii = "G";
        8'h33: ascii = "H";
        8'h43: ascii = "I";
        8'h3B: ascii = "J";
        8'h42: ascii = "K";
        8'h4B: ascii = "L";
        8'h3A: ascii = "M";
        8'h31: ascii = "N";
        8'h44: ascii = "O";
        8'h4D: ascii = "P";
        8'h15: ascii = "Q";
        8'h2D: ascii = "R";
        8'h1B: ascii = "S";
        8'h2C: ascii = "T";
        8'h3C: ascii = "U";
        8'h2A: ascii = "V";
        8'h1D: ascii = "W";
        8'h22: ascii = "X";
        8'h35: ascii = "Y";
        8'h1A: ascii = "Z";
        8'h45: ascii = "0";
        8'h16: ascii = "1";
        8'h1E: ascii = "2";
        8'h26: ascii = "3";
        8'h25: ascii = "4";
        8'h2E: ascii = "5";
        8'h36: ascii = "6";
        8'h3D: ascii = "7";
        8'h3E: ascii = "8";
        8'h46: ascii = "9";
        8'h0E: ascii = "`";	
        8'h4E: ascii = "-";	
        8'h55: ascii = "=";	
        8'h5D: ascii = "\\";
        8'h29: ascii = " ";
        8'h76: ascii = 8'h03; //// escape
        8'h54: ascii = "]";
        8'h5B: ascii = "]";
        8'h4C: ascii = ";";
        8'h52: ascii = "'";
        8'h41: ascii = ",";
        8'h49: ascii = ".";
        8'h4A: ascii = "/";
        8'h7C: ascii = "*";
        8'h7B: ascii = "-";
        8'h79: ascii = "+";
        8'h66: ascii = 8'hF7; // backspace
        8'h5A: ascii = "\n"; // enter
      default: ascii = 8'hFF;
    endcase
end

endmodule

module Keyboard_DEMO(
    //// input 100 MHz clock
    input wire clk,
    input wire rst,
    input wire ps2_clk,
    input wire ps2_data,
    // input wire clr,
    input wire text_button,
    input wire background_button,
    output wire ready,
    //// Horizontal sync pulse for VGA controller
    output wire hsync,
    //// Vertical sync pulse for VGA controller
    output wire vsync,
    //// RGB 4-bit singal that go to a DAC (range 0V <-> 0.7V) to generate a color intensity
    output wire [`RGB_RESOLUTION-1:0] r,
    output wire [`RGB_RESOLUTION-1:0] g,
    output wire [`RGB_RESOLUTION-1:0] b
);

wire [7:0] ascii;
wire [7:0] scan_code;
wire ready;
wire busy;
// wire [12:0] address;
reg [12:0] address;
wire underflow;
wire next;

ASCII_Keyboard keyboard(
    .clk(!clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .oe(1),
    .next(!busy),
    .ascii(ascii),
    .ready(ready),
    .underflow(underflow)
);

VGA_Terminal vga_term(
    .clk(clk),
    .rst(rst),
    .hsync(hsync),
    .vsync(vsync),
    .r(r),
    .g(g),
    .b(b),
    .values({
        32'h0,
        32'h0,
        {20'h0, address},
        {24'h0, ascii},

        32'h0,
        32'h0,
        conflict,
        32'h0,
        
        32'h0,
        32'h0,
        32'h0,
        32'h0,
        
        32'h0,
        32'h0,
        32'h0,
        32'h0,
        
        32'h0,
        32'h0,
        32'h0,
        32'h0
    }),
    .address(address),
    .data(ascii),
    .cs(ready),
    .busy(busy),
    .text(text_color_reg),
    .background(background_color_reg)
);

reg [2:0] text_color_reg;
reg [2:0] background_color_reg;
reg previous_tsync;
reg previous_bsync;
reg previously_backspace;
reg previously_busy;
reg [31:0] conflict;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        text_color_reg = 3'b010;
        background_color_reg = 3'b000;
        previous_tsync = 0;
        previous_bsync = 0;
        address = 0;
        previously_busy = 1;
        conflict = 0;
    end
    else
    begin
        if(ready && !busy)
        begin
            if(ascii == "\n")
            begin
            address = (address + 80) - (address % 80);
            end
            else if(ascii == 8'hF7)
            begin
                address = address - 1;
            end
            else
            begin
                address = address + 1;
            end                            
        end
        //// Background color change
        if(!background_button && previous_bsync)
        begin
            background_color_reg = background_color_reg + 1;
            previous_bsync = 0;
        end
        if(background_button && !previous_bsync)
        begin
            previous_bsync = 1;
        end
        //// Text color change
        if(!text_button && previous_tsync)
        begin
            text_color_reg = text_color_reg + 1;
            previous_tsync = 0;
        end
        if(text_button && !previous_tsync) 
        begin
            previous_tsync = 1;
        end
    end
end

endmodule