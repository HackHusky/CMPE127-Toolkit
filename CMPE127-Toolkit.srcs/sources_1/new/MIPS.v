`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// Endianess
// 0 -> little-endian. 1 -> big-endian
//------------------------------------------------------------------------------
`define LITTLE_ENDIAN      0                   //
`define BIG_ENDIAN         1                   //

//------------------------------------------------------------------------------
// Exception Vector
//------------------------------------------------------------------------------
`define VECTOR_BASE_RESET      32'h0000_0010   // MIPS Standard is 0xBFC0_0000. Reset, soft-reset, NMI
`define VECTOR_BASE_BOOT       32'h0000_0000   // MIPS Standard is 0xBFC0_0200. Bootstrap (Status_BEV = 1)
`define VECTOR_BASE_NO_BOOT    32'h0000_0000   // MIPS Standard is 0x8000_0000. Normal (Status_BEV = 0)
`define VECTOR_OFFSET_GENERAL  32'h0000_0000   // MIPS Standard is 0x0000_0180. General exception, but TBL
`define VECTOR_OFFSET_SPECIAL  32'h0000_0008   // MIPS Standard is 0x0000_0200. Interrupts (Cause_IV = 1)

//------------------------------------------------------------------------------
/*
    Encoding for the MIPS Release 1 Architecture

    3 types of instructions:
        - R   : Register-Register
        - I   : Register-Immediate
        - J   : Jump

    Format:
    ------
        - R : Opcode(6) + Rs(5) + Rt(5) + Rd(5) + shamt(5) +  function(6)
        - I : Opcode(6) + Rs(5) + Rt(5) + Imm(16)
        - J : Opcode(6) + Imm(26)
*/
//------------------------------------------------------------------------------
// Opcode field for special instructions
//------------------------------------------------------------------------------
`define OP_TYPE_R               6'b00_0000          // Special
`define OP_TYPE_REGIMM          6'b00_0001          // Branch/Trap

//------------------------------------------------------------------------------
// Instructions fields
//------------------------------------------------------------------------------
`define INSTR_OPCODE       31:26
`define INSTR_RS           25:21
`define INSTR_RT           20:16
`define INSTR_RD           15:11
`define INSTR_SHAMT        10:6
`define INSTR_FUNCT        5:0
`define INSTR_IMM16        15:0
`define INSTR_IMM26        25:0

//------------------------------------------------------------------------------
// Opcode list
//------------------------------------------------------------------------------
`define OP_ADDI                 6'b00_1000
`define OP_ADDIU                6'b00_1001
`define OP_ANDI                 6'b00_1100
`define OP_BEQ                  6'b00_0100
`define OP_BGEZ                 `OP_TYPE_REGIMM
`define OP_BGEZAL               `OP_TYPE_REGIMM
`define OP_BGTZ                 6'b00_0111
`define OP_BLEZ                 6'b00_0110
`define OP_BLTZ                 `OP_TYPE_REGIMM
`define OP_BLTZAL               `OP_TYPE_REGIMM
`define OP_BNE                  6'b00_0101
`define OP_J                    6'b00_0010
`define OP_JAL                  6'b00_0011
`define OP_LB                   6'b10_0000
`define OP_LBU                  6'b10_0100
`define OP_LH                   6'b10_0001
`define OP_LHU                  6'b10_0101
`define OP_LL                   6'b11_0000
`define OP_LUI                  6'b00_1111
`define OP_LW                   6'b10_0011
`define OP_ORI                  6'b00_1101
`define OP_SB                   6'b10_1000
`define OP_SC                   6'b11_1000
`define OP_SH                   6'b10_1001
`define OP_SLTI                 6'b00_1010
`define OP_SLTIU                6'b00_1011
`define OP_SW                   6'b10_1011
`define OP_XORI                 6'b00_1110

//------------------------------------------------------------------------------
// Function field for R(2)-type instructions
//------------------------------------------------------------------------------
`define FUNCTION_OP_ADD         6'b10_0000
`define FUNCTION_OP_ADDU        6'b10_0001
`define FUNCTION_OP_AND         6'b10_0100
`define FUNCTION_OP_BREAK       6'b00_1101
`define FUNCTION_OP_CLO         6'b10_0001
`define FUNCTION_OP_CLZ         6'b10_0000
`define FUNCTION_OP_DIV         6'b01_1010
`define FUNCTION_OP_DIVU        6'b01_1011
`define FUNCTION_OP_JALR        6'b00_1001
`define FUNCTION_OP_JR          6'b00_1000
`define FUNCTION_OP_MFHI        6'b01_0000
`define FUNCTION_OP_MFLO        6'b01_0010
`define FUNCTION_OP_MOVN        6'b00_1011
`define FUNCTION_OP_MOVZ        6'b00_1010
`define FUNCTION_OP_MSUB        6'b00_0100
`define FUNCTION_OP_MSUBU       6'b00_0101
`define FUNCTION_OP_MTHI        6'b01_0001
`define FUNCTION_OP_MTLO        6'b01_0011
`define FUNCTION_OP_MULT        6'b01_1000
`define FUNCTION_OP_MULTU       6'b01_1001
`define FUNCTION_OP_NOR         6'b10_0111
`define FUNCTION_OP_OR          6'b10_0101
`define FUNCTION_OP_SLL         6'b00_0000
`define FUNCTION_OP_SLLV        6'b00_0100
`define FUNCTION_OP_SLT         6'b10_1010
`define FUNCTION_OP_SLTU        6'b10_1011
`define FUNCTION_OP_SRA         6'b00_0011
`define FUNCTION_OP_SRAV        6'b00_0111
`define FUNCTION_OP_SRL         6'b00_0010
`define FUNCTION_OP_SRLV        6'b00_0110
`define FUNCTION_OP_SUB         6'b10_0010
`define FUNCTION_OP_SUBU        6'b10_0011
`define FUNCTION_OP_SYSCALL     6'b00_1100
`define FUNCTION_OP_XOR         6'b10_0110

//------------------------------------------------------------------------------
// Branch >/< zero (and link), traps: Rt
//------------------------------------------------------------------------------
`define RT_OP_BGEZ              5'b00001
`define RT_OP_BGEZAL            5'b10001
`define RT_OP_BLTZ              5'b00000
`define RT_OP_BLTZAL            5'b10000
`define RT_OP_TEQI              5'b01100
`define RT_OP_TGEI              5'b01000
`define RT_OP_TGEIU             5'b01001
`define RT_OP_TLTI              5'b01010
`define RT_OP_TLTIU             5'b01011
`define RT_OP_TNEI              5'b01110

//------------------------------------------------------------------------------
// Rs field for Coprocessor instructions
//------------------------------------------------------------------------------
`define RS_OP_MFC               5'b00000
`define RS_OP_MTC               5'b00100

//------------------------------------------------------------------------------
// ERET
//------------------------------------------------------------------------------
`define RS_OP_ERET              5'b10000
`define FUNCTION_OP_ERET        6'b01_1000

//------------------------------------------------------------------------------
// SYSTEM CONSTANTS
//------------------------------------------------------------------------------
`define OP_CODE_WIDTH           6
`define ALU_FUNCTION_WIDTH      6
`define ALU_OP_CODE_WIDTH       `ALU_FUNCTION_WIDTH
`define FUNCTION_WIDTH          6
`define REGISTER_WIDTH          32
`define NUMBER_OF_REGISTERS     32
`define STACK_POINTER           29
`define INSTRUCTION_WIDTH       32
`define RETURN_ADDRESS_REGISTER 31

module MIPS(
    input wire clk,
    input wire rst,
    output wire BusCycle,
    output wire MemWrite,
    output wire MemRead,
    output wire [`REGISTER_WIDTH-1:0] AddressBus,
    output wire [`REGISTER_WIDTH-1:0] DataBus,
    output wire [`REGISTER_WIDTH-1:0] ProgramCounter,
    output wire [`REGISTER_WIDTH-1:0] ALUResult,
    input wire  [`REGISTER_WIDTH-1:0] Instruction
);

assign AddressBus       = (BusCycle) ? alu_result : `REGISTER_WIDTH'bZ;
assign ALUResult        = alu_result;
assign ProgramCounter   = pc;
assign mips_instruction = Instruction;

//// R-type instruction
wire [ 5:0] opcode                 = mips_instruction[31:26];
wire [ 4:0] register_source        = mips_instruction[25:21];
wire [ 4:0] register_target        = mips_instruction[20:16];
wire [ 4:0] register_destination   = mips_instruction[15:11];
wire [ 4:0] shift_amount           = mips_instruction[10:6];
wire [ 5:0] funct                  = mips_instruction[5:0];
//// I-type instruction field
wire [15:0] immediate              = mips_instruction[15:0];
//// J-type instruction field
wire [25:0] jump_address           = mips_instruction[25:0];

wire [`INSTRUCTION_WIDTH-1:0] mips_instruction;
wire [`REGISTER_WIDTH-1:0] final_pc;
wire [`REGISTER_WIDTH-1:0] next_pc;
// wire BusCycle;
wire less_than_eq, greater_than;

PROCESSOR_DECODER decoder(
    .opcode(opcode),
    .funct(funct),
    .zero(zero),
    .less_than_eq(less_than_eq),
    .greater_than(greater_than),
    .BusCycle(BusCycle),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .MemToReg(MemToReg),
    .Jump(Jump),
    .RegisterJump(RegisterJump),
    .ALUOp(ALUOp),
    .PCSrc(PCSrc),
    .PCToReg(PCToReg)
);

wire [`REGISTER_WIDTH-1:0] pc;

REGISTER #(.WIDTH(`REGISTER_WIDTH)) pc_register (
	.rst(rst),
	.clk(clk),
	.load(1'b1),
	.in(final_pc),
	.Q(pc)
);

ADDER #(.WIDTH(`REGISTER_WIDTH)) adder (
	.a(pc), 
    .b(32'h4),
	.y(next_pc)
);

wire [1:0] RegDst;

MUX #(
    .WIDTH($clog2(`NUMBER_OF_REGISTERS)),
    .INPUTS(3)
) register_destination_mux (
    .select(RegDst),
    .in({ `RETURN_ADDRESS_REGISTER, register_target, register_destination }),
    .out(write_address)
);

wire RegWrite;
wire [`REGISTER_WIDTH-1:0] read_data_1, read_data_2;
// wire [$clog2(`NUMBER_OF_REGISTERS)-1:0] read_address_1, read_address_2;
wire [$clog2(`NUMBER_OF_REGISTERS)-1:0] write_address;
wire [`REGISTER_WIDTH-1:0] write_data;

REGFILE regfile(
	.clk(clk),
	.read_address_1(register_source), 
    .read_address_2(register_target), 
    .write_address(write_address),
	.write_enable(RegWrite),
	.write_data(write_data),
	.read_data_1(read_data_1), 
    .read_data_2(read_data_2)
);

wire [`REGISTER_WIDTH-1:0] immediate_sign_extended;

SIGN_EXTEND #(
    .INPUT_WIDTH(16),
    .OUTPUT_WIDTH(32)
) extend_immediate (
	.a(immediate),
	.y(immediate_sign_extended)
);

wire [`REGISTER_WIDTH-1:0] immediate_extended_shifted;

SHIFT_LEFT #(.AMOUNT(2))
branch_shift_immediate
(
	.a(immediate_sign_extended),
	.y(immediate_extended_shifted)
);

ADDER #(.WIDTH(`REGISTER_WIDTH)) branch_pc_adder (
	.a(immediate_extended_shifted),
    .b(next_pc),
	.y(branch_pc)
);

wire [`REGISTER_WIDTH-1:0] branch_pc, branch_path_pc;
wire PCSrc;

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(2)
) branch_or_next_pc_mux (
    .select(PCSrc),
    .in({ branch_pc, next_pc }),
    .out(branch_path_pc)
);

wire Jump;

wire [`REGISTER_WIDTH-1:0] return_address;

ADDER #(.WIDTH(`REGISTER_WIDTH)) instruction_after_jump (
	.a(pc),
    .b(32'h4),
	.y(return_address)
);

wire [`REGISTER_WIDTH-1:0] jump_pc;
wire RegisterJump;

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(2)
) jump_pc_mux (
    .select(RegisterJump),
    .in({ alu_result , immediate_extended_shifted }),
    .out(jump_pc)
);

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(2)
) final_pc_mux (
    .select(Jump),
    .in({ jump_pc, branch_path_pc }),
    .out(final_pc)
);

wire [`REGISTER_WIDTH-1:0] alu_b;
wire ALUSrc;

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(2)
) alu_source_mux (
    .select(ALUSrc),
    .in({immediate_sign_extended, read_data_2}),
    .out(alu_b)
);

wire [`ALU_OP_CODE_WIDTH-1:0] ALUOp;
wire [`REGISTER_WIDTH-1:0] alu_result;
wire zero;

ALU alu(
	.a(read_data_1),
    .b(alu_b),
	.ALUOp(ALUOp),
    .shift_amount(shift_amount),
	.result(alu_result),
	.zero(zero),
    .less_than_eq(less_than_eq), 
    .greater_than(greater_than)
);


TRIBUFFER #(.WIDTH(`REGISTER_WIDTH))
buffer_databus
(
	.oe(MemWrite),
	.in(read_data_2),
	.out(DataBus)
);

wire MemToReg;
wire [`REGISTER_WIDTH-1:0] memory_to_reg_data;

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(2)
) mem_to_reg (
    .select(MemToReg),
    .in({ DataBus, alu_result }),
    .out(memory_to_reg_data)
);

wire PCToReg;

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(2)
) pc_to_reg (
    .select(PCToReg),
    .in({ return_address, memory_to_reg_data }),
    .out(write_data)
);

// wire MemWrite, MemRead;
// wire [`REGISTER_WIDTH-1:0] DataBus;
endmodule

module PROCESSOR_DECODER(
    input wire [`OP_CODE_WIDTH-1:0]  opcode,
    input wire [`FUNCTION_WIDTH-1:0] funct,
    input wire                      zero,
    input wire                      less_than_eq,
    input wire                      greater_than,
    output wire                     BusCycle,
    output reg [1:0]                RegDst,
    output reg                      RegWrite,
    output reg                      ALUSrc,
    output reg                      MemWrite,
    output reg                      MemRead,
    output reg                      MemToReg,
    output reg                      Jump,
    output reg                      RegisterJump,
    output reg                      PCToReg,
    output reg [`ALU_OP_CODE_WIDTH-1:0]  ALUOp,
    output reg                     PCSrc
);

assign BusCycle = (MemRead | MemWrite);

`define ALUSRC_FOR_RTYPE  0
`define ALUSRC_FOR_ITYPE  1

`define PCSRC_NEXT_INSTRUCTION 0
`define PCSRC_BRANCH_VALUE     1

`define REGDST_FROM_RTYPE  0
`define REGDST_FROM_ITYPE  1
`define REGDST_RETURN_ADDR 2

`define ALU_NULL_OPCODE   `ALU_OP_CODE_WIDTH'b0

`define UNSUPPORTED_OPERATIONS   \
            RegWrite    <= 1'bx; \
            RegDst      <= 1'bx; \
            ALUSrc      <= 1'bx; \
            MemWrite    <= 1'bx; \
            MemRead     <= 1'bx; \
            MemToReg    <= 1'bx; \
            Jump        <= 1'bx; \
            RegisterJump<= 1'bx; \
            PCToReg     <= 1'bx; \
            PCSrc       <= 1'bx; \
            ALUOp       <= 1'bx

// assign {nbranch, regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump,  pcspr, rawr, aluop} = controls;

// always @(*)
// begin
//     case(opcode)
//         `OP_TYPE_R: controls <= 12'b0_1_1_0_0_0_0_0_1_0_10; //Rtype
//         `OP_LW:     controls <= 12'b0_1_0_1_0_0_1_0_0_0_00; //LW
//         `OP_SW:     controls <= 12'b0_0_0_1_0_1_0_0_0_0_00; //SW
//         `OP_BEQ:    controls <= 12'b0_0_0_0_1_0_0_0_0_0_01; //BEQ
//         `OP_BNE:    controls <= 12'b1_0_0_0_0_0_0_0_0_0_01; //BNE
//         `OP_ADDI:   controls <= 12'b0_1_0_1_0_0_0_0_1_0_00; //ADDI
//         `OP_J:      controls <= 12'b0_0_0_0_0_0_0_1_0_0_00; //J
//         `OP_JAL:    controls <= 12'b0_1_0_0_0_0_0_1_0_1_00; //JAL
//         default:    controls <= 12'bx_x_x_x_x_x_x_x_x_x_xx; //???
//     endcase
// end

// `define IMMEDIATE_VERSION_OF_RTYPE `DECODER_CONTROL_WIDTH'b010100001010
wire [`ALU_OP_CODE_WIDTH-1:0] immediate_funct;

IMMEDIATE_TO_ALU_CONVERTER imm_to_alu (
    .opcode(opcode),
    .instruction_function(funct),
    .alu_funct(immediate_funct)
);

always @(*)
begin
    case(opcode)
        `OP_TYPE_R: begin
            RegWrite    <= 1;
            RegDst      <= `REGDST_FROM_RTYPE;
            ALUSrc      <= `ALUSRC_FOR_RTYPE;
            MemWrite    <= 0;
            MemRead     <= 0;
            MemToReg    <= 0;
            PCSrc       <= 0;
            case(funct)
                `FUNCTION_OP_JR,
                `FUNCTION_OP_JALR: begin
                    RegisterJump <= 1;
                    Jump <= 1; 
                end
                default: begin 
                    RegisterJump <= 0;
                    Jump <= 0;
                end
            endcase
            PCToReg     <= 0;
            ALUOp       <= funct;
        end
        `OP_ADDI,
        `OP_ADDIU,
        `OP_ANDI,
        `OP_ORI,  
        `OP_SLTI, 
        `OP_SLTIU, 
        `OP_XORI: begin 
            RegWrite    <= 1;
            RegDst      <= `REGDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            MemWrite    <= 0;
            MemRead     <= 0;
            MemToReg    <= 0;
            PCSrc       <= 0;
            Jump        <= 0;
            RegisterJump<= 0;
            PCToReg     <= 0;
            ALUOp       <= immediate_funct;
        end
        `OP_BEQ: begin
            RegWrite    <= 0;
            RegDst      <= 0;
            ALUSrc      <= 0;
            MemWrite    <= 0;
            MemRead     <= 0;
            MemToReg    <= 0;
            Jump        <= 0;
            RegisterJump<= 0;
            PCToReg     <= 0;
            PCSrc       <= (zero) ? `PCSRC_BRANCH_VALUE : `PCSRC_NEXT_INSTRUCTION;
            ALUOp       <= `FUNCTION_OP_SUB;
        end
        `OP_BNE: begin
            RegWrite    <= 0;
            RegDst      <= 0;
            ALUSrc      <= 0;
            MemWrite    <= 0;
            MemRead     <= 0;
            MemToReg    <= 0;
            Jump        <= 0;
            RegisterJump<= 0;
            PCToReg     <= 0;
            PCSrc       <= (!zero) ? `PCSRC_BRANCH_VALUE : `PCSRC_NEXT_INSTRUCTION;
            ALUOp       <= `FUNCTION_OP_SUB;
        end
        `OP_BGTZ: begin
            RegWrite    <= 0;
            RegDst      <= 0;
            ALUSrc      <= 0;
            MemWrite    <= 0;
            MemRead     <= 0;
            MemToReg    <= 0;
            Jump        <= 0;
            RegisterJump<= 0;
            PCToReg     <= 0;
            PCSrc       <= (greater_than) ? `PCSRC_BRANCH_VALUE : `PCSRC_NEXT_INSTRUCTION;
            ALUOp       <= `FUNCTION_OP_SUB;
        end
        `OP_BLEZ: begin
            RegWrite    <= 0;
            RegDst      <= 0;
            ALUSrc      <= 0;
            MemWrite    <= 0;
            MemRead     <= 0;
            MemToReg    <= 0;
            Jump        <= 0;
            RegisterJump<= 0;
            PCToReg     <= 0;
            PCSrc       <= (less_than_eq) ? `PCSRC_BRANCH_VALUE : `PCSRC_NEXT_INSTRUCTION;
            ALUOp       <= `FUNCTION_OP_SUB;
        end
        `OP_BGEZAL,
        `OP_BLTZAL: begin
            `UNSUPPORTED_OPERATIONS;
        end
        `OP_J: begin
            RegWrite    <= 0;
            RegDst      <= 0;
            ALUSrc      <= 0;
            MemWrite    <= 0;
            MemRead     <= 0;
            MemToReg    <= 0;
            Jump        <= 1;
            PCToReg     <= 0;
            PCSrc       <= 0;
            ALUOp       <= `ALU_NULL_OPCODE;
        end
        `OP_JAL: begin
            RegWrite    <= 1;
            RegDst      <= `REGDST_RETURN_ADDR;
            ALUSrc      <= 0;
            MemWrite    <= 0;
            MemRead     <= 0;
            MemToReg    <= 0;
            Jump        <= 1;
            PCToReg     <= 1;
            PCSrc       <= 0;
            ALUOp       <= `ALU_NULL_OPCODE;
        end
        `OP_LB,
        `OP_LBU,
        `OP_LH,
        `OP_LHU,
        `OP_LL,
        `OP_LUI: begin
            `UNSUPPORTED_OPERATIONS;
        end
        `OP_LW: begin
            RegWrite    <= 1;
            RegDst      <= `REGDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            MemWrite    <= 0;
            MemRead     <= 1;
            MemToReg    <= 1;
            Jump        <= 0;
            RegisterJump<= 0;
            PCToReg     <= 0;
            PCSrc       <= 0;
            ALUOp       <= `FUNCTION_OP_ADD;
        end
        `OP_SB, 
        `OP_SC, 
        `OP_SH: begin
            `UNSUPPORTED_OPERATIONS;
        end 
        `OP_SW: begin
            RegWrite    <= 0;
            RegDst      <= `REGDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            MemWrite    <= 1;
            MemRead     <= 0;
            MemToReg    <= 0;
            Jump        <= 0;
            RegisterJump<= 0;
            PCToReg     <= 0;
            PCSrc       <= 0;
            ALUOp       <= `FUNCTION_OP_ADD;
        end
        default: begin // unsupported opcode
            `UNSUPPORTED_OPERATIONS;
        end
    endcase
end
endmodule


module IMMEDIATE_TO_ALU_CONVERTER (
    input wire [`OP_CODE_WIDTH-1:0]      opcode,
    input wire [`FUNCTION_WIDTH-1:0] instruction_function,
    output reg [`ALU_FUNCTION_WIDTH-1:0] alu_funct
);

always @(*)
begin
    case (opcode)
        `OP_TYPE_R:  alu_funct <= instruction_function;
        `OP_ADDI:    alu_funct <= `FUNCTION_OP_ADD;
        `OP_ADDIU:   alu_funct <= `FUNCTION_OP_ADD;
        `OP_ANDI:    alu_funct <= `FUNCTION_OP_AND;
        `OP_BEQ:     alu_funct <= `FUNCTION_OP_SUB;
        //`OP_BGEZ:    alu_funct <= `FUNCTION_OP_BGEZ;
        //`OP_BGEZAL:  alu_funct <= `FUNCTION_OP_BGEZAL;
        //`OP_BGTZ:    alu_funct <= `FUNCTION_OP_BGTZ;
        //`OP_BLEZ:    alu_funct <= `FUNCTION_OP_BLEZ;
        //`OP_BLTZ:    alu_funct <= `FUNCTION_OP_BLTZ;
        //`OP_BLTZAL:  alu_funct <= `FUNCTION_OP_BLTZAL;
        //`OP_BNE:     alu_funct <= `FUNCTION_OP_BNE;
        //`OP_JAL:     alu_funct <= `FUNCTION_OP_JAL;
        //`OP_LB:      alu_funct <= `FUNCTION_OP_LB;
        //`OP_LBU:     alu_funct <= `FUNCTION_OP_LBU;
        //`OP_LH:      alu_funct <= `FUNCTION_OP_LH;
        //`OP_LHU:     alu_funct <= `FUNCTION_OP_LHU;
        //`OP_LL:      alu_funct <= `FUNCTION_OP_LL;
        //`OP_LUI:     alu_funct <= `FUNCTION_OP_LUI;
        //`OP_LW:      alu_funct <= `FUNCTION_OP_LW;
        `OP_ORI:     alu_funct <= `FUNCTION_OP_OR;
        //`OP_SB:      alu_funct <= `FUNCTION_OP_SB;
        //`OP_SC:      alu_funct <= `FUNCTION_OP_SC;
        //`OP_SH:      alu_funct <= `FUNCTION_OP_SH;
        `OP_SLTI:    alu_funct <= `FUNCTION_OP_SLTI;
        //`OP_SLTIU:   alu_funct <= `FUNCTION_OP_SLTIU;
        //`OP_SW:      alu_funct <= `FUNCTION_OP_SW;
        `OP_XORI :   alu_funct <= `FUNCTION_OP_XOR;
        default:     alu_funct <= `ALU_FUNCTION_WIDTH'b0;
    endcase
end

endmodule

module ADDER #(parameter WIDTH = 32)
(
	input  wire signed [WIDTH-1:0]	a, 
    input  wire signed [WIDTH-1:0]	b,
	output wire signed [WIDTH-1:0]	y
);

assign y = a + b;

endmodule

// register file with one write port and three read ports
// the 3rd read port is for prototyping dianosis
module REGFILE #(
    parameter WIDTH = 32,
    parameter COUNT = 32
)
(
	input wire  clk,
	input wire  [$clog2(COUNT)-1:0] read_address_1, 
    input wire  [$clog2(COUNT)-1:0] read_address_2, 
    input wire  [$clog2(COUNT)-1:0] write_address,
	input wire  write_enable,
	input wire  [WIDTH-1:0] write_data,
	output wire [WIDTH-1:0] read_data_1, 
    output wire [WIDTH-1:0] read_data_2
);

reg		[31:0]	register_file [0:COUNT];

assign read_data_1 = (read_address_1 != 0) ? register_file[read_address_1] : 0;
assign read_data_2 = (read_address_2 != 0) ? register_file[read_address_2] : 0;

//initialize registers to all 0s
integer n;
initial 
begin
    for (n=0; n<COUNT; n=n+1)
    begin
        register_file[n] = { (WIDTH) { 1'b0 } };
    end
    //// set stack pointer to position 63
    // register_file[`STACK_POINTER] = 63;
end

//write first order, include logic to handle special case of $0
always @(posedge clk)
begin
    if (write_enable)
    begin
        register_file[write_address] <= write_data;
    end
end

endmodule

module ALU(
	input wire 	[`REGISTER_WIDTH-1:0]	    a,
    input wire 	[`REGISTER_WIDTH-1:0]       b,
	input wire 	[`ALU_FUNCTION_WIDTH-1:0]   ALUOp,
    input wire  [5:0]                       shift_amount,
	output reg	[`REGISTER_WIDTH-1:0]       result,
	output wire			                    zero,
    output wire			                    less_than_eq,
    output wire			                    greater_than
);

wire signed [`REGISTER_WIDTH-1:0] signed_a; 
wire signed [`REGISTER_WIDTH-1:0] signed_b;

assign signed_a = a;
assign signed_b = b;

assign zero         = (result == 32'b0);
assign less_than_eq = (signed_a <= 0);
assign greater_than = (signed_a > 0);

always@(*)
begin
    case(ALUOp)
        `FUNCTION_OP_ADD:       result <=  (signed_a + signed_b);
        `FUNCTION_OP_ADDU:      result <=  (a + b);
        `FUNCTION_OP_AND:       result <=  (a & b);
        `FUNCTION_OP_BREAK:     result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_CLO:       result <= `REGISTER_WIDTH'hxxxxxxxx; // count leading ones
        `FUNCTION_OP_CLZ:       result <= `REGISTER_WIDTH'hxxxxxxxx; // count leading zeros
        `FUNCTION_OP_DIV:       result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_DIVU:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_JALR:      result <=  a;
        `FUNCTION_OP_JR:        result <=  a;
        `FUNCTION_OP_MFHI:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_MFLO:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_MOVN:      result <= (b == 32'b0);
        `FUNCTION_OP_MOVZ:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_MSUB:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_MSUBU:     result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_MTHI:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_MTLO:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_MULT:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_MULTU:     result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_NOR:       result <= ~(a | b);
        `FUNCTION_OP_OR:        result <=  (a | b);
        `FUNCTION_OP_SLL:       result <=  (a << shift_amount);
        `FUNCTION_OP_SLLV:      result <=  (a << b);
        `FUNCTION_OP_SLT:       result <=  (signed_a < signed_b) ? 32'b1 : 32'b0;
        `FUNCTION_OP_SLTU:      result <=  (a < b) ? 32'b1 : 32'b0;
        `FUNCTION_OP_SRA:       result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_SRAV:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_SRL:       result <=  (a >> shift_amount);
        `FUNCTION_OP_SRLV:      result <=  (a >> b);
        `FUNCTION_OP_SUB:       result <=  (signed_a - signed_b);
        `FUNCTION_OP_SUBU:      result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_SYSCALL:   result <= `REGISTER_WIDTH'hxxxxxxxx;
        `FUNCTION_OP_XOR:       result <=  (a ^ b);
        default:                result <= `REGISTER_WIDTH'hxxxxxxxx;
    endcase
end

endmodule

module SIGN_EXTEND #(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 32
)
(
	input  wire [INPUT_WIDTH-1:0]   a,
	output wire [OUTPUT_WIDTH-1:0]  y
);

assign y = { { (OUTPUT_WIDTH-INPUT_WIDTH){ a[INPUT_WIDTH-1] } }, a };

endmodule

module SHIFT_LEFT #(parameter AMOUNT = 2) 
(
	input wire [`REGISTER_WIDTH-1:0]	a,
	output wire	[`REGISTER_WIDTH-1:0]	y
);

// shift left by 2
assign y = (a << AMOUNT);

endmodule

module MULT #(parameter WIDTH = 32)(
    input wire  [WIDTH-1:0] a, 
    input wire  [WIDTH-1:0] b, 
    output wire [(WIDTH*2)-1:0] out
);

assign out = a * b;

endmodule