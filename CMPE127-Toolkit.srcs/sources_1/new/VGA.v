`timescale 1ns / 1ps
`default_nettype none
 
`define VGA_RAM_ADDRESS_WIDTH 	 12
`define PIXEL_WIDTH 			 8
`define ASCII_WIDTH 			 8
`define SCREEN_WIDTH 			 640
`define SCREEN_HEIGHT			 480
`define TERMINAL_ROWS 			 30
`define TERMINAL_COLUMNS         80
`define VALUE_BIT_WIDTH  		 32
`define HORIZONTAL_SEGMENTS 	 4
`define HARDWARE_CONTROLLED_ROWS 6
`define TOTAL_SEGMENTS 		     (`HORIZONTAL_SEGMENTS*(`HARDWARE_CONTROLLED_ROWS-1))
`define FREQ_IN  				 100_000_000
`define FREQ_OUT 				 25_000_000
`define RGB_RESOLUTION  		 4

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

module VGA_Terminal_DEMO(
    //// input 100 MHz clock
    input wire clk,
    input wire rst,
    //// Horizontal sync pulse for VGA controller
    output wire hsync,
    //// Vertical sync pulse for VGA controller
    output wire vsync,
    //// RGB 4-bit singal that go to a DAC (range 0V <-> 0.7V) to generate a color intensity
    output wire [`RGB_RESOLUTION-1:0] r,
    output wire [`RGB_RESOLUTION-1:0] g,
    output wire [`RGB_RESOLUTION-1:0] b,
    //// 12-bit address bus to address which location in video ram to write ascii characters to
    //// The address is linear
    input wire [8:0] address,
    //// 7-bit data input bus 
    input wire [6:0] data,
    //// chip select for this VGA Terminal module
    input wire cs,
    //// busy signal to tell CPU or other hardware that the VGA controller cannot be writen to.
    output wire busy
);

//// These wires are used to demonstrate values changing on screen
wire [`VALUE_BIT_WIDTH-1:0] debug_value_0;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_1;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_2;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_3;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_4;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_5;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_6;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_7;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_8;
wire [`VALUE_BIT_WIDTH-1:0] debug_value_9;

wire [`ASCII_WIDTH-1:0] sign_extend_data;
wire [`VGA_RAM_ADDRESS_WIDTH-1:0] sign_extend_address;

assign sign_extend_data = { 1'b0, data };
assign sign_extend_address = { 4'b0, address };

DEMO_DEBUG_VALUE_GENERATOR demo(
    .clk(clk),
    .rst(rst),
    .debug_value_0(debug_value_0),
    .debug_value_1(debug_value_1),
    .debug_value_2(debug_value_2),
    .debug_value_3(debug_value_3),
    .debug_value_4(debug_value_4),
    .debug_value_5(debug_value_5),
    .debug_value_6(debug_value_6),
    .debug_value_7(debug_value_7),
    .debug_value_8(debug_value_8),
    .debug_value_9(debug_value_9)
);

VGA_Terminal(
    .clk(clk),
    .rst(rst),
    .hsync(hsync),
    .vsync(vsync),
    .r(r),
    .g(g),
    .b(b),
    .values({
        debug_value_0,
        debug_value_1,
        debug_value_2,
        debug_value_3,
        32'h12345678,
        debug_value_4,
        debug_value_5,
        debug_value_6,
        debug_value_7,
        32'h9ABCDEF0,
        debug_value_8,
        debug_value_9,
        32'h22222222,
        32'h33333333,
        32'h44444444,
        32'h55555555,
        32'h66666666,
        32'h77777777,
        32'h88888888,
        32'hDEADBEEF
    }),
    .address(sign_extend_address),
    .data(sign_extend_data),
    .cs(cs),
    .busy(busy)
);

endmodule

module VGA_Terminal(
    //// input 100 MHz clock
    input wire clk,
    input wire rst,
    //// Horizontal sync pulse for VGA controller
    output wire hsync,
    //// Vertical sync pulse for VGA controller
    output wire vsync,
    //// RGB 4-bit singal that go to a DAC (range 0V <-> 0.7V) to generate a color intensity
    output wire [`RGB_RESOLUTION-1:0] r,
    output wire [`RGB_RESOLUTION-1:0] g,
    output wire [`RGB_RESOLUTION-1:0] b,
    input wire [(`TOTAL_SEGMENTS*`VALUE_BIT_WIDTH)-1:0] values,
    //// 12-bit address bus to address which location in video ram to write ascii characters to
    //// The address is linear
    input wire [`VGA_RAM_ADDRESS_WIDTH-1:0] address,
    //// 8-bit data input bus 
    input wire [`ASCII_WIDTH-1:0] data,
    //// chip select for this VGA Terminal module
    input wire cs,
    //// busy signal to tell CPU or other hardware that the VGA controller cannot be writen to.
    output wire busy,
    input wire [2:0] text,
    input wire [2:0] background
);
// ==================================
//// Internal Parameter Field
// ==================================
// ==================================
//// Registers
// ==================================
// ==================================
//// Wires
// ==================================
/** 
 * VGA Terminal Signals
 */
//// Pixel clock (for 640x480 screen this will be set to 25MHz)
wire pclk;
//// Converts the top level address to an address beyond the hardware controlled area
wire [`VGA_RAM_ADDRESS_WIDTH-1:0] external_address;
//// Signal from control unit that will 
wire enable_rgb;
//// xyadress will convert the hcount and vcount into the appropriate address of video ram
wire [`VGA_RAM_ADDRESS_WIDTH-1:0] xyaddress;
//// Will hold the row of pixels corrisponding to an ascii glyph to print to screen.
wire [`PIXEL_WIDTH-1:0] pixels;
/** 
 * VGA Controller Signals
 */
//// hcount indicates the horizontal pixel location or x coordinate
wire [31:0] hcount;
//// vcount indicates the vertical pixel location or y coordinate
wire [31:0] vcount;
//// hblank indicates when the VGA controller is in the horizontal blanking (reseting) stage
wire hblank;
//// vblank indicates when the VGA controller is in the vertical blanking (reseting) stage
wire vblank;
/** 
 * CONTROL UNIT WIRES 
 */
//// Control unit's video address output. 
//// Control unit will assert an address when it wants to write or read from video ram
wire [`VGA_RAM_ADDRESS_WIDTH-1:0] video_ctrl_address;
//// Control unit's buffer address output.
//// Control unit will assert an address when it wants to write or read from buffer ram
wire [`VGA_RAM_ADDRESS_WIDTH-1:0] buffer_ctrl_address;
//// Video Address Bus 
//// 	(TODO: MAY REMOVE IN PLACE OF VIDEO_ADDR_BUS)
wire [`VGA_RAM_ADDRESS_WIDTH-1:0] video_address;
//// Buffer Address Bus
//// 	(TODO: MAY REMOVE IN PLACE OF BUFFER_ADDR_BUS)
wire [`VGA_RAM_ADDRESS_WIDTH-1:0] buffer_address;
//// Video Data Bus
wire [`ASCII_WIDTH-1:0] video_data;
//// Buffer Data Bus
wire [`ASCII_WIDTH-1:0] buffer_data;
//// Control unit signal to select xy_address or video_ctrl_address
//// 	(TODO: MAY OPTIMIZE OUT)
wire xy_count_select;
//// Control unit buffer data bus output control
////	(TODO: MAY OPTIMIZE OUT)
wire buffer_out_control;
//// switches between control unit cs and external cs
wire buffer_ctrl_cs;
//// Video ram control signals
wire video_wr;
wire video_cs;
wire video_oe;
//// Buffer ram control signals
wire buffer_wr;
wire buffer_cs;
wire buffer_oe;
// ==================================
//// Wire Assignments
// ==================================
assign busy = buffer_ctrl_cs;
//// RGB should be disabled zero when hlank or vblank asserted.
assign enable_rgb = !(hblank | vblank);
//// Adds 80*5 to the top level address to move the memory boundary away from hardware controlled memory.
assign external_address = address+(`TERMINAL_COLUMNS*`HARDWARE_CONTROLLED_ROWS);
// ==================================
//// Modules
// ==================================
PixelClock pixel_clock_generator(
    .clk100Mhz(clk),
    .rst(rst),
    .pclk(pclk)
);

VGA vga_controller(
    .pclk(pclk),
    .rst(rst),
    .hsync(hsync),
    .vsync(vsync),
    .hcount(hcount),
    .vcount(vcount),
    .hblank(hblank),
    .vblank(vblank)
);

VGA_Terminal_Control_Unit cu(
    .pclk(clk),
    .rst(rst),
    .vblank(vblank),
    .hblank(hblank),
    .values(values),
    .video_address(video_ctrl_address),
    .buffer_address(buffer_ctrl_address),
    .external_address(external_address),
    .video_data(video_data),
    .buffer_data(buffer_data),
    .xy_count_select(xy_count_select),
    .buffer_out_control(buffer_out_control),
    .video_wr(video_wr),
    .video_cs(video_cs),
    .video_oe(video_oe),
    .buffer_wr(buffer_wr),
    .buffer_cs(buffer_ctrl_cs),
    .buffer_oe(buffer_oe)
);

ConvertXYToAddress linearize(
    .hcount(hcount),
    .vcount(vcount),
    .address(xyaddress)
);

MUX #(
    .WIDTH(12),
    .INPUTS(2)
) ram_address_mux (
    .select(xy_count_select),
    .in({xyaddress, video_ctrl_address}),
    .out(video_address)
);

RAM #(
.WIDTH(8), 
.LENGTH(2400)
) video_ram (
    .clk(clk),
    .we(video_wr),
    .cs(video_cs),
    .oe(video_oe),
    .address(video_address),
    .data(video_data)
);

MUX #(
    .WIDTH(12),
    .INPUTS(2)
) buffer_address_mux (
    .select(buffer_ctrl_cs),
    .in({buffer_ctrl_address, external_address }),
    .out(buffer_address)
);

MUX #(
    .WIDTH(1),
    .INPUTS(2)
) buffer_cs_mux (
    .select(buffer_ctrl_cs),
    .in({buffer_ctrl_cs, cs}),
    .out(buffer_cs)
);

TRIBUFFER#(.WIDTH(`ASCII_WIDTH)) tristate_switch_data_bus (
    .oe(!buffer_ctrl_cs),
    .in(data),
    .out(buffer_data)
);

RAM #(
.WIDTH(8), 
.LENGTH(2400)
) buffer_ram(
    .clk(clk),
    .we(buffer_wr),
    .cs(buffer_cs),
    .oe(buffer_oe),
    .address(buffer_address),
    .data(buffer_data)
);

FontROM rom(
    .ascii(video_data),
    .column(vcount[3:0]),
    .pixels(pixels)
);

PixelRender pixel_renderer(
    .enable(enable_rgb),
    .hcount(hcount),
    .pixels(pixels),
    .r(r),
    .g(g),
    .b(b),
    .text(text),
    .background(background)
);
// ==================================
//// Behavioral Block
// ==================================
endmodule

module VGA_Terminal_Control_Unit(
    input wire pclk,
    input wire rst,
    input wire vblank,
    input wire hblank,
    input wire [(`TOTAL_SEGMENTS*`VALUE_BIT_WIDTH)-1:0] values,
    output reg [11:0] video_address,
    output reg [11:0] buffer_address,
    input wire [11:0] external_address,
    inout wire [7:0] video_data,
    inout wire [7:0] buffer_data,
    output reg xy_count_select,
    output reg buffer_out_control,
    output reg video_wr,
    output reg video_cs,
    output reg video_oe,
    output reg buffer_wr,
    output reg buffer_cs,
    output reg buffer_oe
);
// ==================================
//// Internal Parameter Field
// ==================================
//// State parameters
parameter LOAD_RAMS 			= 0;
parameter WAIT_FOR_VBLANK 		= 1;
parameter WRITE_HEX_TO_BUFFER 	= 2;
parameter COPY_BUFFER_TO_VIDEO 	= 3;
parameter WAIT_OUT_VBLANK  		= 4;
parameter STATE_WIDTH           = $clog2(WAIT_OUT_VBLANK);
// ==================================
//// Registers
// ==================================
reg [STATE_WIDTH-1:0] state;
reg [`ASCII_WIDTH-1:0] video_data_out;
reg [`ASCII_WIDTH-1:0] buffer_data_out;
reg [3:0] temp_value;
reg video_out_control;
integer previous_position;
integer i;
integer v;
// ==================================
//// Wires
// ==================================
wire [(`HARDWARE_CONTROLLED_ROWS*`TERMINAL_COLUMNS*`ASCII_WIDTH)-1:0] strings = {
    "       PC:0x","FFFFFFFF","  RD DATA:0x","FFFFFFFF","   DEBUG0:0x","FFFFFFFF","   DEBUG5:0x","FFFFFFFF",
    "   ALUOUT:0x","FFFFFFFF","  WR DATA:0x","FFFFFFFF","   DEBUG1:0x","FFFFFFFF","   DEBUG6:0x","FFFFFFFF",
    "  REGOUT1:0x","FFFFFFFF","   CP0$12:0x","FFFFFFFF","   DEBUG2:0x","FFFFFFFF","   DEBUG7:0x","FFFFFFFF",
    "  REGOUT2:0x","FFFFFFFF","   CP0$13:0x","FFFFFFFF","   DEBUG3:0x","FFFFFFFF","   DEBUG8:0x","FFFFFFFF",
    "  REGOUT3:0x","FFFFFFFF","   CP0$14:0x","FFFFFFFF","   DEBUG4:0x","FFFFFFFF","   DEBUG9:0x","FFFFFFFF",
    "------------","--------","------------","--DEBUG ","MONITOR-----","--------","------------","--------"
};
// ==================================
//// Wire Assignments
// ==================================
assign video_data  = (video_out_control)  ? video_data_out  : 8'hZ;
assign buffer_data = (buffer_out_control) ? buffer_data_out : 8'hZ;
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
always @(posedge pclk or posedge rst) begin
    if (rst) begin
        // set state
        state = 0;
        // set internal variables
        i = 0;
        v = 0;
        previous_position = 0;
        temp_value = 0;
        // Set out going signals
        video_out_control = 0;
        buffer_out_control = 0;
        video_data_out = 0;
        
        buffer_data_out = 0;
        video_address = 0;
        buffer_address = 0;
        xy_count_select = 0;
        video_wr = 0;
        video_cs = 0;
        video_oe = 0;
        buffer_wr = 0;
        buffer_cs = 0;
        buffer_oe = 0;
    end
    else begin
        case(state)
            LOAD_RAMS: begin
                if(i < `TERMINAL_COLUMNS*`TERMINAL_ROWS) begin
                    xy_count_select 	= 0;
                    video_wr 		    = 1;
                    video_cs 		    = 1;
                    video_oe 		    = 0;
                    buffer_wr 			= 1;
                    buffer_cs 			= 1;
                    buffer_oe 			= 0;
                    video_out_control   = 1;
                    buffer_out_control 	= 1;

                    video_address 		= i;
                    buffer_address 		= i;

                    buffer_data_out 	= (strings >> ((`TERMINAL_COLUMNS*`HARDWARE_CONTROLLED_ROWS)-(i+1))*`ASCII_WIDTH);
                    video_data_out 		= (strings >> ((`TERMINAL_COLUMNS*`HARDWARE_CONTROLLED_ROWS)-(i+1))*`ASCII_WIDTH);

                    i = i + 1;
                end
                else begin
                    i = 0;
                    state = WAIT_FOR_VBLANK;
                end
            end
            WAIT_FOR_VBLANK: begin
                xy_count_select 	= 1;
                video_wr 			= 0;
                video_cs 			= 1;
                video_oe 			= 1;
                buffer_wr 			= 1; // to allow user to write to ram
                buffer_cs 			= 0;
                buffer_oe 			= 0;

                video_out_control 	= 0;
                buffer_out_control 	= 0;
                buffer_data_out 	= 0;
                
                video_data_out 		= 0;

                if(vblank)
                begin
                    state = WRITE_HEX_TO_BUFFER;
                    i = 12;
                    v = 0;
                    previous_position = i;
                end
            end
            WRITE_HEX_TO_BUFFER: begin
                xy_count_select 	= 0;

                video_wr 		    = 0;
                video_cs 		    = 0;
                video_oe 		    = 0;

                buffer_wr 			= 1;
                buffer_cs 			= 1;
                buffer_oe 			= 0;

                video_out_control 	= 0;
                buffer_out_control 	= 1;
                buffer_address 		= i;

                temp_value = (values >> (`TOTAL_SEGMENTS*`VALUE_BIT_WIDTH)-(4*(v+1)));

                case(temp_value)
                    4'h0: buffer_data_out = "0";
                    4'h1: buffer_data_out = "1";
                    4'h2: buffer_data_out = "2";
                    4'h3: buffer_data_out = "3";
                    4'h4: buffer_data_out = "4";
                    4'h5: buffer_data_out = "5";
                    4'h6: buffer_data_out = "6";
                    4'h7: buffer_data_out = "7";
                    4'h8: buffer_data_out = "8";
                    4'h9: buffer_data_out = "9";
                    4'hA: buffer_data_out = "A";
                    4'hB: buffer_data_out = "B";
                    4'hC: buffer_data_out = "C";
                    4'hD: buffer_data_out = "D";
                    4'hE: buffer_data_out = "E";
                    4'hF: buffer_data_out = "F";
                endcase
                
                if(i > (`TERMINAL_COLUMNS*(`HARDWARE_CONTROLLED_ROWS-1)-1))
                begin
                    state = COPY_BUFFER_TO_VIDEO;
                    i = 0;
                end
                else if(i == previous_position+7)
                begin
                    previous_position = previous_position + 20;
                    i = previous_position;
                    v = v + 1;
                end
                else begin
                    i = i + 1;
                    v = v + 1;
                end

            end
            COPY_BUFFER_TO_VIDEO: begin
                xy_count_select 	= 0;

                video_wr 		    = 1;
                video_cs 		    = 1;
                video_oe 		    = 0;

                buffer_wr 			= 0;
                buffer_cs 			= 1;
                buffer_oe 			= 1;

                video_out_control   = 1;
                buffer_out_control  = 0;

                buffer_address 		= i;
                video_address 		= (i > 1) ? i-2 : 0;

                if(buffer_address == external_address+2)
                begin
                    video_data_out = 8'h81;
                end
                else
                begin
                    video_data_out = buffer_data;  
                end
                

                if(i < (`TERMINAL_COLUMNS*`TERMINAL_ROWS)-1) begin
                    i = i + 1;
                end
                else
                begin
                    state = WAIT_OUT_VBLANK;
                end
            end
            WAIT_OUT_VBLANK: begin
                buffer_wr 			= 0;
                buffer_cs 			= 0;
                buffer_oe 			= 0;
                video_out_control   = 0;
                buffer_out_control  = 0;
                if(!vblank)
                begin
                    state = WAIT_FOR_VBLANK;
                end
            end
            default: begin
                state = 0;
            end
        endcase
    end
end

endmodule

module DEMO_DEBUG_VALUE_GENERATOR(
    input wire clk,
    input wire rst,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_0,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_1,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_2,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_3,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_4,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_5,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_6,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_7,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_8,
    output reg [`VALUE_BIT_WIDTH-1:0] debug_value_9
);
// ==================================
//// Internal Parameter Field
// ==================================
// ==================================
//// Registers
// ==================================
reg [31:0] counter0 = 0;
reg [31:0] counter1 = 0;
// ==================================
//// Wires
// ==================================
// ==================================
//// Wire Assignments
// ==================================
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset
        counter0 = 0;
        counter1 = 0;
        debug_value_0 = 0;
        debug_value_1 = 0;
        debug_value_2 = 0;
        debug_value_3 = 0;
        debug_value_4 = 0;
        debug_value_5 = 0;
        debug_value_6 = 0;
        debug_value_7 = 0;
        debug_value_8 = 0;
        debug_value_9 = 0;
    end
    else begin
        counter0 = counter0 + 1;
        counter1 = counter1 + 1;
        if(counter0 == 32'd10_000_000)
        begin
            debug_value_0 = debug_value_0 - 1;
            debug_value_1 = debug_value_1 - 5;
            debug_value_2 = debug_value_2 - 10;
            debug_value_3 = debug_value_3 - 2;
            debug_value_4 = debug_value_4 - 13;
            debug_value_5 = debug_value_5 - 7;
            debug_value_6 = debug_value_6 - 3;
            counter0 = 0;
        end
        if(counter1 == 32'd50_000_000)
        begin
            debug_value_7 = debug_value_7 + 1;
            debug_value_8 = debug_value_8 + 5;
            debug_value_9 = debug_value_9 + 10;
            counter1 = 0;
        end
    end
end

endmodule

module ConvertXYToAddress (
    input wire [31:0] hcount,
    input wire [31:0] vcount,
    output wire [11:0] address
);

// (y*COLUMNS) + x
assign address = (vcount[31:4] * `TERMINAL_COLUMNS) + hcount[31:3];

endmodule

module PixelRender
(
    input wire  enable,
    input wire  [31:0] hcount,
    input wire  [`PIXEL_WIDTH-1:0] pixels,
    output wire [`RGB_RESOLUTION-1:0] r,
    output wire [`RGB_RESOLUTION-1:0] g,
    output wire [`RGB_RESOLUTION-1:0] b,
    input wire [2:0] text,
    input wire [2:0] background
);

assign r = (pixels[7-hcount[2:0]] && enable) ? { text[0], text[0], text[0], text[0] } : { background[0], background[0], background[0], background[0] };
assign g = (pixels[7-hcount[2:0]] && enable) ? { text[1], text[1], text[1], text[1] } : { background[1], background[1], background[1], background[1] };
assign b = (pixels[7-hcount[2:0]] && enable) ? { text[2], text[2], text[2], text[2] } : { background[2], background[2], background[2], background[2] };

endmodule

module ColorModule(
    input wire pclk,
    input wire [31:0] hcount,
    input wire [31:0] vcount,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b
);

assign r = (  0 < vcount && vcount <= 200 && hcount < 640) ? 4'hF : 0;
assign g = (200 < vcount && vcount <= 400 && hcount < 640) ? 4'hF : 0;
assign b = (400 < vcount && vcount <= 480 && hcount < 640) ? 4'hF : 0;

endmodule

module PixelClock(
    input wire clk100Mhz,
    input wire rst,
    output reg pclk
);
// ==================================
//// Internal Parameter Field
// ==================================
parameter HOLD_TICK_COUNT = (`FREQ_IN/`FREQ_OUT)/2;
// ==================================
//// Registers
// ==================================
reg [15:0] count;
// ==================================
//// Wires
// ==================================
// ==================================
//// Wire Assignments
// ==================================
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
always @(posedge clk100Mhz or posedge rst)
begin
    if(rst)
    begin
        count = 0;
        pclk  = 0;
    end
    else
    begin
       count = count + 1;
       if(count == HOLD_TICK_COUNT)
       begin
          count = 0;
          pclk = !pclk;
       end
    end
end
endmodule

module VGA(
    input wire pclk,
    input wire rst,
    output reg hsync,
    output reg vsync,
    output reg [31:0] hcount,
    output reg [31:0] vcount,
    output reg hblank,
    output reg vblank
);

// ==================================
//// Internal Parameter Field
// ==================================
parameter DISPLAY_WIDTH  = `SCREEN_WIDTH-1;
parameter DISPLAY_HEIGHT = `SCREEN_HEIGHT-1;
parameter HORIZONTAL_FRONT_PORCH = 16;
parameter HORIZONTAL_SYNC_PULSE = 96;
parameter HORIZONTAL_BACK_PORCH = 48;
parameter VERTICAL_FRONT_PORCH = 11;
parameter VERTICAL_SYNC_PULSE = 2;
parameter VERTICAL_BACK_PORCH = 31;
// ==================================
//// Registers
// ==================================
// ==================================
//// Wires
// ==================================
wire hsyncon, hsyncoff, hreset, hblankon;
wire vsyncon, vsyncoff, vreset, vblankon;
// ==================================
//// Wire Assignments
// ==================================
assign hblankon = (hcount == DISPLAY_WIDTH);
assign hsyncon  = (hcount == DISPLAY_WIDTH+HORIZONTAL_FRONT_PORCH);
assign hsyncoff = (hcount == DISPLAY_WIDTH+HORIZONTAL_FRONT_PORCH+HORIZONTAL_SYNC_PULSE);
assign hreset   = (hcount == DISPLAY_WIDTH+HORIZONTAL_FRONT_PORCH+HORIZONTAL_SYNC_PULSE+HORIZONTAL_BACK_PORCH);

assign vblankon = (hreset & (vcount == DISPLAY_HEIGHT));
assign vsyncon  = (hreset & (vcount == DISPLAY_HEIGHT+VERTICAL_FRONT_PORCH));
assign vsyncoff = (hreset & (vcount == DISPLAY_HEIGHT+VERTICAL_FRONT_PORCH+VERTICAL_SYNC_PULSE));
assign vreset   = (hreset & (vcount == DISPLAY_HEIGHT+VERTICAL_FRONT_PORCH+VERTICAL_SYNC_PULSE+VERTICAL_BACK_PORCH));
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
always @(posedge pclk or posedge rst)
begin
    if (rst)
    begin
        hcount = 0;
        vcount = 0;
        hblank = 0;
        hsync  = 0;
        vblank = 0;
        vsync  = 0;
    end
    else
    begin
        hcount = hreset  ? 0 :  hcount   + 1;
        hblank = hreset  ? 0 : (hblankon ? 1 : hblank);
        hsync  = hsyncon ? 0 : (hsyncoff ? 1 : hsync);

        vcount = hreset  ? (vreset ? 0 : vcount + 1) : vcount;
        vblank = vreset  ? 0 : (vblankon ? 1 : vblank);
        vsync  = vsyncon ? 0 : (vsyncoff ? 1 : vsync);
    end
end

endmodule

