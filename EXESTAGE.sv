`include "constants.sv" 
module EXEStage (
	//control signal
	input logic [`FORW_SEL_LEN-1:0] Forward_A, 
	input logic [`FORW_SEL_LEN-1:0] Forward_B, 
	input logic Reg_W_En_IN, 
	input logic Mem_W_En_IN, 
	input logic Mem_R_En_IN,
	input logic Imsel,
	input logic [1:0] ALUOp,
	input logic [1:0] WBsel_IN,
	//register value
    input logic [`WORD_LEN-1:0] rd1, 
	input logic [`WORD_LEN-1:0] rd2_IN, 
	input logic [`WORD_LEN-1:0] ImmG, 
	input logic [`WORD_LEN-1:0] PC, 
	input logic [`WORD_LEN-1:0] PCplus4_IN,
	input logic [`WORD_LEN-1:0] Instruction_IN,
	//forwarding 
	input logic [`WORD_LEN-1:0] ALURes_EXE2MEM,
	input logic [`WORD_LEN-1:0] Mem_Data_MEM2WB,
	//register value
    output logic [`WORD_LEN-1:0] ALURes, 
	output logic [`WORD_LEN-1:0] PCplus4, 
	output logic [`WORD_LEN-1:0] rd2,
	output logic [`WORD_LEN-1:0] Instruction,
	//control signal
	output logic [1:0] WBsel, 
	output logic Reg_W_En, 
	output logic Mem_W_En, 
	output logic Mem_R_En,
	//feedback to IF
	output logic [`WORD_LEN-1:0] BrOffset
);

  logic [`WORD_LEN-1:0] forwardA_res, forwardB_res, ALUb;
  logic [`EXE_CMD_LEN-1:0] EXE_CMD;

  // Mux for selecting the first ALU operand based on forwarding
  mux_3input #(.WIDTH(`WORD_LEN)) muxA (
    .in1(rd1),
    .in2(Mem_Data_MEM2WB),
    .in3(ALURes_EXE2MEM),
    .sel(Forward_A),
    .out(forwardA_res)
  );

  // Mux for selecting the second ALU operand based on forwarding
  mux_3input #(.WIDTH(`WORD_LEN)) muxB (
    .in1(rd2_IN),
    .in2(Mem_Data_MEM2WB),
    .in3(ALURes_EXE2MEM),
    .sel(Forward_B),
    .out(forwardB_res)
  );
  
    // Multiplexer for determining if take immediate
    mux #(.WIDTH(`WORD_LEN)) mux2 (
        .in1(forwardB_res),
        .in2(ImmG),
        .sel(Imsel),
        .out(ALUb)
    );

    // Branch target generation
    BranchGen BranchGen_inst (
        .ImmG(ImmG),
        .PC(PC),
        .BrOffset(BrOffset)
    );
	
	//ALU Control
    ALUControl ALUControl_inst (
		.ALUOp(ALUOp),
		.funct7(Instruction_IN[31:25]),
		.funct3(Instruction_IN[14:12]),
		.EXE_CMD(EXE_CMD)
	);
	
	// ALU 
	alu  #(.WIDTH(`WORD_LEN), .LENGTH(`EXE_CMD_LEN)) 
		alu_inst (
		.aluA(forwardA_res),
		.aluB(ALUb),
		.EXE_CMD(EXE_CMD),
		.ALUResult(ALURes)
	);
  

	
	assign rd2 = rd2_IN;
	assign Instruction = Instruction_IN;
	assign PCplus4 = PCplus4_IN;
	assign Reg_W_En = Reg_W_En_IN;
	assign WBsel = WBsel_IN;
	assign Mem_W_En = Mem_W_En_IN;
	assign Mem_R_En = Mem_R_En_IN;
	
endmodule // EXEStage
