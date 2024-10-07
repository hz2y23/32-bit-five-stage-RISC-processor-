`include "constants.sv"  

module cpu (
    input logic clk,
    input logic nReset,
	input logic [`WORD_LEN-1:0] SW,
	output logic [`WORD_LEN-1:0] LED
);
    logic [`WORD_LEN-1:0] PC_IF, PC_IF2ID, PC_ID, PC_ID2EXE;
	logic [`WORD_LEN-1:0] PCplus4_IF, PCplus4_IF2ID, PCplus4_ID, PCplus4_ID2EXE, PCplus4_EXE, PCplus4_EXE2MEM, PCplus4_MEM, PCplus4_MEM2WB;
	logic [`WORD_LEN-1:0] Inst_IF, Inst_IF2ID, Inst_ID, Inst_ID2EXE, Inst_EXE, Inst_EXE2MEM, Inst_MEM, Inst_MEM2WB;
	logic [`WORD_LEN-1:0] ImmG_ID, ImmG_ID2EXE;
    logic [`WORD_LEN-1:0] rd1_ID, rd1_ID2EXE;
    logic [`WORD_LEN-1:0] rd2_ID, rd2_ID2EXE, rd2_EXE, rd2_EXE2MEM;
    logic [`WORD_LEN-1:0] ALURes_EXE, ALURes_EXE2MEM, ALURes_MEM, ALURes_MEM2WB;
    logic [`WORD_LEN-1:0] Mem_Data_MEM, Mem_Data_MEM2WB;
    logic [`WORD_LEN-1:0] WB_result;
	logic [`WORD_LEN-1:0] BrOffset_EXE;
    logic [`FORW_SEL_LEN-1:0] Forward_A, Forward_B, Forward_C, Forward_D;
    logic [1:0] ALUOp_ID, ALUOp_ID2EXE;
	logic [1:0] WBsel_ID, WBsel_ID2EXE, WBsel_EXE, WBsel_EXE2MEM, WBsel_MEM, WBsel_MEM2WB;
    logic BranchTK_ID, BranchTK_ID2EXE;
    logic Mem_R_En_ID, Mem_R_En_ID2EXE, Mem_R_En_EXE, Mem_R_En_EXE2MEM;
    logic Mem_W_En_ID, Mem_W_En_ID2EXE, Mem_W_En_EXE, Mem_W_En_EXE2MEM;
    logic Reg_W_En_ID, Reg_W_En_ID2EXE, Reg_W_En_EXE, Reg_W_En_EXE2MEM, Reg_W_En_MEM, Reg_W_En_MEM2WB;
    logic Imsel_ID, Imsel_ID2EXE;
	logic stall, stall_twice;
	logic flush;

	regFile #(
    .ADDR_LEN(`REG_FILE_ADDR_LEN),
    .DATA_WIDTH(`WORD_LEN),
    .REG_FILE_SIZE(`REG_FILE_SIZE)
	) regFile_inst(
		// INPUTS
		.clk(clk),
		.nReset(nReset),
		.rs1(Inst_IF2ID[19:15]),
		.rs2(Inst_IF2ID[24:20]),
		.write_register(Inst_MEM2WB[11:7]),
		.write_data(WB_result),
		.writeEn(Reg_W_En_MEM2WB),
		// OUTPUTS
		.rd1(rd1_ID),
		.rd2(rd2_ID)
	);

	Hazard_Detection hazard_inst (
		// INPUTS
		.rs1_IF2ID(Inst_IF2ID[19:15]),
		.rs2_IF2ID(Inst_IF2ID[24:20]),
		.rd_ID2EXE(Inst_ID2EXE[11:7]),
		.Mem_R_En_ID2EXE(Mem_R_En_ID2EXE),
		.BranchTK_ID(BranchTK_ID),
		.Reg_W_En_ID2EXE(Reg_W_En_ID2EXE),
		.Opcode_IF2ID(Inst_IF2ID[6:0]),
		.Opcode_ID2EXE(Inst_ID2EXE[6:0]),
		// OUTPUTS
		.stall(stall),
		.stall_twice(stall_twice)
	);

	Forwarding_Unit forwarding_inst (
		.rs1_IF2ID(Inst_IF2ID[19:15]),
		.rs2_IF2ID(Inst_IF2ID[24:20]),
		.rs1_ID2EXE(Inst_ID2EXE[19:15]),
		.rs2_ID2EXE(Inst_ID2EXE[24:20]),
		.rd_ID2EXE(Inst_ID2EXE[11:7]),
		.rd_EXE2MEM(Inst_EXE2MEM[11:7]),
		.rd_MEM2WB(Inst_MEM2WB[11:7]),
		.Reg_W_En_ID2EXE(Reg_W_En_ID2EXE),
		.Reg_W_En_EXE2MEM(Reg_W_En_EXE2MEM),
		.Reg_W_En_MEM2WB(Reg_W_En_MEM2WB),
		.Inst_IF2ID(Inst_IF2ID),
		.Inst_ID2EXE(Inst_ID2EXE),
		.Inst_MEM2WB(Inst_MEM2WB),
		.Inst_EXE2MEM(Inst_EXE2MEM),
		.Forward_A(Forward_A),
		.Forward_B(Forward_B),
		.Forward_C(Forward_C),
		.Forward_D(Forward_D)
	);
	
	//###########################
	//##### PIPLINE STAGES ######
	//###########################
	IFStage IFStage_inst (
		// INPUTS
		.clk(clk),
		.nReset(nReset),
		.stall(stall),
		.stall_twice(stall_twice),
		.BranchTK(BranchTK_ID2EXE),
		.BrOffset(BrOffset_EXE),
		// OUTPUTS
		.Instruction(Inst_IF),
		.PC(PC_IF),
		.PCplus4(PCplus4_IF)
	);

	IF2ID IF2IDReg (
		// INPUTS
		.clk(clk),
		.nReset(nReset),
		.flush(flush),
		.stall(stall),
		.stall_twice(stall_twice),
		.PC_IN(PC_IF),
		.PCplus4_IN(PCplus4_IF),
		.Instruction_IN(Inst_IF),
		// OUTPUTS
		.PC(PC_IF2ID),
		.PCplus4(PCplus4_IF2ID),
		.Instruction(Inst_IF2ID)
	);

	IDStage IDStage_inst (
		// INPUTS
		.Instruction_IN(Inst_IF2ID),
		.PC_IN(PC_IF2ID),
		.PCplus4_IN(PCplus4_IF2ID),
		.rd1(rd1_ID),
		.rd2(rd2_ID),
		.ALURes_EXE(ALURes_EXE),
		.Mem_Data_MEM(Mem_Data_MEM),
		.Forward_C(Forward_C),
		.Forward_D(Forward_D),
		// OUTPUTS
		.ALUOp(ALUOp_ID),
		.Imsel(Imsel_ID),
		.BranchTK(BranchTK_ID),
		.Reg_W_En(Reg_W_En_ID),
		.Mem_R_En(Mem_R_En_ID),
		.Mem_W_En(Mem_W_En_ID),
		.WBsel(WBsel_ID),
		.ImmG(ImmG_ID),
		.Instruction(Inst_ID),
		.PC(PC_ID),
		.PCplus4(PCplus4_ID)
	);

	ID2EXE ID2EXEReg (
		.clk(clk),
		.nReset(nReset),
		// INPUTS
		.flush(flush),
		.stall(stall),
		.stall_twice(stall_twice),
		.Mem_R_En_IN(Mem_R_En_ID),
		.Mem_W_En_IN(Mem_W_En_ID),
		.Reg_W_En_IN(Reg_W_En_ID),
		.BranchTK_IN(BranchTK_ID),
		.Imsel_IN(Imsel_ID),
		.ALUOp_IN(ALUOp_ID),
		.WBsel_IN(WBsel_ID),
		.rd1_IN(rd1_ID),
		.rd2_IN(rd2_ID),
		.ImmG_IN(ImmG_ID),
		.PC_IN(PC_ID),
		.PCplus4_IN(PCplus4_ID),
		.Instruction_IN(Inst_ID),
		// OUTPUTS
		.Mem_R_En(Mem_R_En_ID2EXE),
		.Mem_W_En(Mem_W_En_ID2EXE),
		.Reg_W_En(Reg_W_En_ID2EXE),
		.BranchTK(BranchTK_ID2EXE),
		.Imsel(Imsel_ID2EXE),
		.ALUOp(ALUOp_ID2EXE),
		.WBsel(WBsel_ID2EXE),
		.rd1(rd1_ID2EXE),
		.rd2(rd2_ID2EXE),
		.ImmG(ImmG_ID2EXE),
		.PC(PC_ID2EXE),
		.PCplus4(PCplus4_ID2EXE),
		.Instruction(Inst_ID2EXE)
	);

	EXEStage EXEStage_inst (
		// INPUTS
		.Forward_A(Forward_A),
		.Forward_B(Forward_B),
		.Reg_W_En_IN(Reg_W_En_ID2EXE),
		.Mem_W_En_IN(Mem_W_En_ID2EXE),
		.Mem_R_En_IN(Mem_R_En_ID2EXE),
		.Imsel(Imsel_ID2EXE),
		.ALUOp(ALUOp_ID2EXE),
		.WBsel_IN(WBsel_ID2EXE),
		.rd1(rd1_ID2EXE),
		.rd2_IN(rd2_ID2EXE),
		.ImmG(ImmG_ID2EXE),
		.PC(PC_ID2EXE),
		.PCplus4_IN(PCplus4_ID2EXE),
		.Instruction_IN(Inst_ID2EXE),
		.ALURes_EXE2MEM(ALURes_EXE2MEM),
		.Mem_Data_MEM2WB(Mem_Data_MEM2WB),
		// OUTPUTS
		.ALURes(ALURes_EXE),
		.PCplus4(PCplus4_EXE),
		.rd2(rd2_EXE),
		.Instruction(Inst_EXE),
		.WBsel(WBsel_EXE),
		.Reg_W_En(Reg_W_En_EXE),
		.Mem_W_En(Mem_W_En_EXE),
		.Mem_R_En(Mem_R_En_EXE),
		.BrOffset(BrOffset_EXE)
	);

	EXE2MEM EXE2MEMReg (
		.clk(clk),
		.nReset(nReset),
		.stall_twice(stall_twice),
		// INPUTS
		.Reg_W_En_IN(Reg_W_En_EXE),
		.Mem_R_En_IN(Mem_R_En_EXE),
		.Mem_W_En_IN(Mem_W_En_EXE),
		.WBsel_IN(WBsel_EXE),
		.rd2_IN(rd2_EXE),
		.PCplus4_IN(PCplus4_EXE),
		.ALURes_IN(ALURes_EXE),
		.Instruction_IN(Inst_EXE),
		// OUTPUTS
		.Reg_W_En(Reg_W_En_EXE2MEM),
		.Mem_R_En(Mem_R_En_EXE2MEM),
		.Mem_W_En(Mem_W_En_EXE2MEM),
		.WBsel(WBsel_EXE2MEM),
		.rd2(rd2_EXE2MEM),
		.PCplus4(PCplus4_EXE2MEM),
		.ALURes(ALURes_EXE2MEM),
		.Instruction(Inst_EXE2MEM)
	);

	MemoryStage MEMStage_inst (
		// INPUTS
		.clk(clk),
		.nReset(nReset),
		.Mem_R_En(Mem_R_En_EXE2MEM),
		.Mem_W_En(Mem_W_En_EXE2MEM),
		.Reg_W_En_IN(Reg_W_En_EXE2MEM),
		.WBsel_IN(WBsel_EXE2MEM),
		.ALURes_IN(ALURes_EXE2MEM),
		.PCplus4_IN(PCplus4_EXE2MEM),
		.rd2(rd2_EXE2MEM),
		.Instruction_IN(Inst_EXE2MEM),
		.SW(SW),
		// OUTPUTS
		.Reg_W_En(Reg_W_En_MEM),
		.WBsel(WBsel_MEM),
		.Mem_Data_or_SW(Mem_Data_MEM),
		.ALURes(ALURes_MEM),
		.PCplus4(PCplus4_MEM),
		.Instruction(Inst_MEM),
		.LED(LED)
	);

	MEM2WB MEM2WBReg(
		.clk(clk),
		.nReset(nReset),
		// INPUTS
		.Reg_W_En_IN(Reg_W_En_MEM),
		.WBsel_IN(WBsel_MEM),
		.ALURes_IN(ALURes_MEM),
		.PCplus4_IN(PCplus4_MEM),
		.Mem_Data_IN(Mem_Data_MEM),
		.Instruction_IN(Inst_MEM),
		// OUTPUTS
		.Reg_W_En(Reg_W_En_MEM2WB),
		.WBsel(WBsel_MEM2WB),
		.ALURes(ALURes_MEM2WB),
		.PCplus4(PCplus4_MEM2WB),
		.Mem_Data(Mem_Data_MEM2WB),
		.Instruction(Inst_MEM2WB)
	);
	
	WBStage WBStage_inst (
		// INPUTS
		.WBsel(WBsel_MEM2WB),
		.Mem_Data(Mem_Data_MEM2WB),
		.PCplus4(PCplus4_MEM2WB),
		.ALURes(ALURes_MEM2WB),
		// OUTPUTS
		.WB_result(WB_result)
	);
	assign flush = BranchTK_ID2EXE;
endmodule
