`timescale 1ns / 1ps
`default_nettype none

`define SCAN_CODE_LENGTH        11
`define SCAN_CODE_DATA_LENGTH   8
`define RGB_RESOLUTION  		4
`define FREQ_IN                 32'd100_000_000
`define BREAK_CODE              8'hF0
`define EXTEND_CODE             8'hE0
`define SHIFT_CODE_LEFT         8'h12        
`define SHIFT_CODE_RIGHT        8'h59

`define LEFT_ARROW              8'h6B
`define DOWN_ARROW              8'h72
`define RIGHT_ARROW             8'hF4
`define UP_ARROW                8'h75

`define LEFT_ARROW_ASCII        8'hEB
`define DOWN_ARROW_ASCII        8'hF2
`define RIGHT_ARROW_ASCII       8'hF4
`define UP_ARROW_ASCII          8'hF5

`define BACKSPACE               8'hF7

`define KEYBOARD_ADDRESS        1781
`define KEYBOARD_READY_ADDRESS  1782
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/25/2017 05:38:31 PM
// Design Name:
// Module Name: Motherboard
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

module CLOCK_GENERATOR #(parameter DIVIDE = 2)
(
    input wire rst,
    input wire fast_clk,
    output reg slow_clk
);

reg [31:0] counter = 0;

always @(posedge fast_clk or posedge rst)
begin
    if(rst)
    begin
        slow_clk <= 0;
        counter <= 0;
    end
    else 
    begin
        if(counter == DIVIDE/2)
        begin
            slow_clk <= ~slow_clk;
            counter <= 0;
        end
        else
        begin
            slow_clk <= slow_clk;
            counter <= counter + 1;
        end
    end
end

endmodule

module Motherboard #(parameter CLOCK_DIVIDER = 100)
(
	//// input 100 MHz clock
    input wire clk100Mhz,
    input wire rst,
    input wire ps2_clk,
    input wire ps2_data,
    //// Horizontal sync pulse for VGA controller
    output wire hsync,
    //// Vertical sync pulse for VGA controller
    output wire vsync,
    //// RGB 4-bit singal that go to a DAC (range 0V <-> 0.7V) to generate a color intensity
    output wire [`RGB_RESOLUTION-1:0] r,
    output wire [`RGB_RESOLUTION-1:0] g,
    output wire [`RGB_RESOLUTION-1:0] b,
    input wire clk_select,
    input wire button_clock,
    output wire show_button
);

assign show_button = button_clock_sync;

// ==================================
//// Internal Parameter Field
// ==================================
// ==================================
//// Wires
// ==================================
wire keyboard_ready;
wire vga_busy;

wire MemRead, BusCycle;
wire [31:0] AddressBus, DataBus, ProgramCounter, ALUResult, RegOut1, RegOut2, RegWriteData, Instruction;
wire [3:0] MemWrite;

wire [7:0] scan_code;
wire [31:0] extended_count;
wire [2:0] text_color;
wire [2:0] background_color;

wire [7:0] vga_DataBus;
wire [11:0] vga_AddressBus;
// ==================================
//// Wire Assignments
// ==================================
assign text_color = 3'b010;
assign background_color = 3'b000;
// ==================================
//// Modules
// ==================================

wire button_clock_sync;
wire cpu_clk;

CLOCK_GENERATOR #(.DIVIDE(CLOCK_DIVIDER)
) clock (
    .rst(rst),
    .fast_clk(clk100Mhz),
    .slow_clk(cpu_clk)
);

 Syncronizer #(
 	.WIDTH(1),
 	.DEFAULT_DISABLED(0)
 ) button_clk (
 	.clk(clk100Mhz),
 	.rst(rst),
 	.en(1'b1),
 	.in(button_clock),
 	.sync_out(button_clock_sync)
);

wire clk;

MUX #(
    .WIDTH(1),
    .INPUTS(2)
) register_destination_mux (
    .select(clk_select),
    .in({ cpu_clk, button_clock_sync }),
    .out(clk)
);

ROM #(
    .LENGTH(32'h1000),
    .WIDTH(32),
    .FILE_NAME("rom.mem")
) rom (
	.a({2'b00, ProgramCounter[31:2]}),
	.out(Instruction)
);

MIPS mips(
    .clk(!clk),
    .rst(rst),
    .BusCycle(BusCycle),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .AddressBus(AddressBus),
    .DataBus(DataBus),
    .ProgramCounter(ProgramCounter),
    .ALUResult(ALUResult),
    .RegOut1(RegOut1),
    .RegOut2(RegOut2),
    .RegWriteData(RegWriteData),
    .Instruction(Instruction)
);

RAM_B #(
    .LENGTH(32'h1000/4),
    .COLUMN(3),
    .USE_FILE(1),
    .FILE_NAME("ram.mem")
) ramb_3 (
    .clk(clk),
    .rst(rst),
    .we(MemWrite[3]),
    .cs(ram_access),
    .oe(MemRead),
    .address(AddressBus[13:2]),
    .data(DataBus[31:24])
);

RAM_B #(
    .LENGTH(32'h1000/4),
    .COLUMN(2),
    .USE_FILE(1),
    .FILE_NAME("ram.mem")
) ramb_2 (
    .clk(clk),
    .rst(rst),
    .we(MemWrite[2]),
    .cs(ram_access),
    .oe(MemRead),
    .address(AddressBus[13:2]),
    .data(DataBus[23:16])
);

 RAM_B #(
    .LENGTH(32'h1000/4),
    .COLUMN(1),
    .USE_FILE(1),
    .FILE_NAME("ram.mem")
) ramb_1 (
    .clk(clk),
    .rst(rst),
    .we(MemWrite[1]),
    .cs(ram_access),
    .oe(MemRead),
    .address(AddressBus[13:2]),
    .data(DataBus[15:8])
);

RAM_B #(
    .LENGTH(32'h1000/4),
    .COLUMN(0),
    .USE_FILE(1),
    .FILE_NAME("ram.mem")
) ramb_0 (
    .clk(clk),
    .rst(rst),
    .we(MemWrite[0]),
    .cs(ram_access),
    .oe(MemRead),
    .address(AddressBus[13:2]),
    .data(DataBus[7:0])
);

wire text_access;
wire extern_access;
wire ram_access;

DECODER #(.INPUT_WIDTH(3)) address_decoder
(
	.enable(1'b1),
	.in(AddressBus[14:12]),
	.out({ ram_access, extern_access, text_access })
);

wire key_cs;
wire key_ready_cs;
wire vga_fifo_cs;

AND #(.WIDTH(2)) key_cs_and (
	.in({ extern_access, (AddressBus == `KEYBOARD_ADDRESS)}),
	.out(key_cs)
);

AND #(.WIDTH(2)) key_ready_cs_and (
	.in({ extern_access, (AddressBus == `KEYBOARD_READY_ADDRESS)}),
	.out(key_ready_cs)
);

AND #(.WIDTH(4)) vga_fifo_cs_and (
	.in({ !key_cs, !key_ready_cs, !ram_access, extern_access}),
	.out(vga_fifo_cs)
);

ASCII_Keyboard keyboard(
    .clk(clk100Mhz),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .oe(key_cs),
    .next(key_cs),
    .ascii(DataBus[7:0]),
    .ready(keyboard_ready),
    .scan_code_reg(scan_code),
    .extended_count(extended_count),
    .command()
);

TRIBUFFER #(.WIDTH(32))
key_ready_buffer
(
	.oe(key_ready_cs),
	.in({ 31'b0, keyboard_ready }),
	.out(DataBus)
);

wire ascii_fifo_empty, address_fifo_empty;

FIFO #(
    .LENGTH(32),
    .WIDTH(8)
) vga_ascii_fifo (
    .clk(clk),
    .rst(rst),
    .wr_cs(vga_fifo_cs),
    .wr_en(|MemWrite),
    .rd_cs(!vga_busy),
    .rd_en(!vga_busy),
    .full(),
    .empty(ascii_fifo_empty),
    .out(vga_DataBus),
    .in(DataBus[7:0])
);


FIFO #(
    .LENGTH(32),
    .WIDTH(12)
) vga_address_fifo (
    .clk(clk),
    .rst(rst),
    .wr_cs(vga_fifo_cs),
    .wr_en(|MemWrite),
    .rd_cs(!vga_busy),
    .rd_en(!vga_busy),
    .full(),
    .empty(address_fifo_empty),
    .out(vga_AddressBus),
    .in({ 1'b0, AddressBus[10:0] })
);

wire vga_cs;

OR #(.WIDTH(2)) fifo_to_vga_cs_and (
	.in({ !ascii_fifo_empty, !address_fifo_empty }),
	.out(vga_cs)
);

VGA_Terminal vga_term(
    .clk(clk100Mhz),
    .rst(rst),
    .hsync(hsync),
    .vsync(vsync),
    .r(r),
    .g(g),
    .b(b),
    .values({
        ProgramCounter,
        DataBus,
        32'h0,
        32'h0,

        ALUResult,
        AddressBus,
        32'h0,
        32'h0,
        
        RegOut1,
        { {(32-12){1'b0}}, 3'b0, BusCycle, 3'b0, MemRead, 3'b0, MemWrite },
        32'h0,
        32'h0,
        
        RegOut2,
        Instruction,
        32'h0,
        32'h0,
        
        RegWriteData,
        32'h0,
        32'h0,
        32'h0
        //mips_instruction
    }),
    .address(vga_AddressBus),
    .data(vga_DataBus),
    .cs(vga_cs),
    .busy(vga_busy),
    .text(text_color),
    .background(background_color)
);

// ==================================
//// Registers
// ==================================
// ==================================
//// Behavioral Block
// ==================================

endmodule