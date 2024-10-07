`include "constants.sv" 
module IFStage (
    input logic clk,
    input logic nReset,
    input logic stall,
	input logic stall_twice,
	//from execute stage
	input logic BranchTK,
    input logic [`WORD_LEN-1:0] BrOffset, 
	//register value
    output logic [`WORD_LEN-1:0] PC, 
	output logic [`WORD_LEN-1:0] PCplus4,
    output logic [`WORD_LEN-1:0] Instruction
);
    logic [`WORD_LEN-1:0] Next_PC;
	
    // Adder to calculate the next PC address
    adder #(.WIDTH(`WORD_LEN)) add1 (
        .in1(32'd4),
        .in2(PC),
        .out(PCplus4)
    );
	
    // Multiplexer for choosing between increment by 4 or branch offset
    mux #(.WIDTH(`WORD_LEN)) mux1 (
        .in1(PCplus4),
        .in2(BrOffset),
        .sel(BranchTK),
        .out(Next_PC)
    );
	
    // Program Counter
    pc #(.WIDTH(`WORD_LEN)) PCReg (
        .clk(clk),
        .nReset(nReset),
        .stall(stall),
		.stall_twice(stall_twice),
        .regIn(Next_PC),
        .regOut(PC)
    );

    // Instruction Memory fetches Instruction at current PC
    instructionMem instructionsMem_inst (
        .nReset(nReset),
        .addr(PC),
        .Instruction(Instruction)
    );


endmodule // IFStage

