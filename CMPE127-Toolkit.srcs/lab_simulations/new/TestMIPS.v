`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2018 04:15:49 PM
// Design Name: 
// Module Name: TestMotherboard
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

module TestMIPS;

reg clk;
reg rst;

wire [31:0] AddressBus, DataBus, ProgramCounter, Instruction, ALUResult;
wire BusCycle, MemWrite, MemRead;

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
    .Instruction(Instruction)
);

wire ram_cs;

OR #(.WIDTH(2))
ram_cs_or
(
    .in({ MemWrite, MemRead }),
	.out(ram_cs)
);

/* Instruction Memory */
ROM #(
    .LENGTH(32'h1000),
    .WIDTH(32),
    .FILE_NAME("CPU_TEST.mem")
) rom (
	.a({2'b00, ProgramCounter[31:2]}),
	.out(Instruction)
);
/* Data Memory */
RAM #(
    .LENGTH(32'd255),
    .WIDTH(32),
    .USE_FILE(0),
    .FILE_NAME("ram.mem")
) ram (
    .clk(clk),
    .we(MemWrite),
    .cs(ram_cs),
    .oe(MemRead),
    .address(AddressBus[9:2]),
    .data(DataBus)
);

task RESET;
begin
    rst = 0;
    clk = 0;
    #5
    rst = 1;
    #5
    rst = 0;
    clk = 0;
end
endtask;

task CLOCK;
	input [31:0] count;
	integer k;
begin
	for (k=0; k < count; k = k+1)
	begin
		#5
		clk = 1;
		#5
		clk = 0;
	end
end
endtask

parameter FULL_CYCLE = 32'd60;

initial begin
    #10
    #10
	RESET;
	CLOCK(FULL_CYCLE);

    #10 $stop;
    #5 $finish;
end

endmodule

