`include "constants.sv" 
module IDStage (
	//register value
    input logic [`WORD_LEN-1:0] Instruction_IN,
	input logic [`WORD_LEN-1:0] PC_IN, 
	input logic [`WORD_LEN-1:0] PCplus4_IN,
	//register file
	input logic [`WORD_LEN-1:0] rd1, 
	input logic [`WORD_LEN-1:0] rd2,
	//forward input
	input logic [`WORD_LEN-1:0] ALURes_EXE,
	input logic [`WORD_LEN-1:0] Mem_Data_MEM,
	input logic [`FORW_SEL_LEN-1:0] Forward_C, 
	input logic [`FORW_SEL_LEN-1:0] Forward_D, 
	//control signal
    output logic [1:0] ALUOp,
	output logic Imsel, 
	output logic BranchTK,
	output logic Reg_W_En,
    output logic Mem_R_En,
    output logic Mem_W_En,
    output logic [1:0] WBsel,
	//register value
    output logic [`WORD_LEN-1:0] ImmG,
	output logic [`WORD_LEN-1:0] Instruction,
	output logic [`WORD_LEN-1:0] PC, 
	output logic [`WORD_LEN-1:0] PCplus4
);
	logic BranchEn, BEQ, BNE, BLT, BGE;
	logic [`WORD_LEN-1:0] forwardA_res, forwardB_res;
    // controller unit
    controller controller_inst(
	    // INPUT
        .Opcode(Instruction_IN[6:0]),
        .BEQ(BEQ),
		.BNE(BNE),
		.BLT(BLT),
		.BGE(BGE),
		// OUTPUT
        .ALUOp(ALUOp),
        .Imsel(Imsel),
        .BranchEn(BranchEn),
		.BranchTK(BranchTK),
        .Reg_W_En(Reg_W_En),
        .Mem_R_En(Mem_R_En),
        .Mem_W_En(Mem_W_En),
		.WBsel(WBsel)
    );
	// Mux for selecting the first branch operand based on forwarding
	mux_3input #(.WIDTH(`WORD_LEN)) muxC (
		.in1(rd1),
		.in2(Mem_Data_MEM),
		.in3(ALURes_EXE),
		.sel(Forward_C),
		.out(forwardA_res)
	);
	
	// Mux for selecting the second branch operand based on forwarding
	mux_3input #(.WIDTH(`WORD_LEN)) muxD (
		.in1(rd2),
		.in2(Mem_Data_MEM),
		.in3(ALURes_EXE),
		.sel(Forward_D),
		.out(forwardB_res)
	);
	
	//Branch Comparator
	branch #(.WIDTH(`WORD_LEN)) branch_inst(
		// INPUT
		.a(forwardA_res), 
		.b(forwardB_res), 
		.BranchEn(BranchEn),
		.func3(Instruction_IN[14:12]),
		// OUTPUT
		.BEQ(BEQ), 
		.BNE(BNE),
		.BLT(BLT),
		.BGE(BGE)
);

    // Immediate geration
    ImmGen #(.WIDTH(`WORD_LEN)) ImmGen_inst(
        .Instruction(Instruction_IN),
        .ImmG(ImmG)
    );
	
	assign PC = PC_IN;
	assign PCplus4 = PCplus4_IN;
	assign Instruction = Instruction_IN;
	
endmodule // IDStage
