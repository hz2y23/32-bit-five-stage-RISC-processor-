`include "opcodes.sv" 
module Forwarding_Unit
    (input logic [4:0] rs1_IF2ID,
     input logic [4:0] rs2_IF2ID,
	 input logic [4:0] rs1_ID2EXE,
     input logic [4:0] rs2_ID2EXE,
	 input logic [4:0] rd_ID2EXE,
     input logic [4:0] rd_EXE2MEM,
     input logic [4:0] rd_MEM2WB,
	 input logic Reg_W_En_ID2EXE,
     input logic Reg_W_En_EXE2MEM,
     input logic Reg_W_En_MEM2WB,
	 input logic [31:0]Inst_IF2ID,
	 input logic [31:0]Inst_ID2EXE,
	 input logic [31:0]Inst_MEM2WB,
	 input logic [31:0]Inst_EXE2MEM,
     output logic [1:0] Forward_A,
     output logic [1:0] Forward_B,
	 output logic [1:0] Forward_C,
     output logic [1:0] Forward_D
	 
    );


always_comb
	begin
	if ((Reg_W_En_EXE2MEM) && (rd_EXE2MEM != 0) && (rd_EXE2MEM == rs1_ID2EXE) && 
	(Inst_ID2EXE[6:0] != `B_Type))
		Forward_A = 2'b10;	//10 EX hazard - ALURes_MEM
	else if (Reg_W_En_MEM2WB && (rd_MEM2WB != 0) && (rd_MEM2WB == rs1_ID2EXE)
	&& (Inst_ID2EXE[6:0] != `B_Type))
		Forward_A = 2'b01;	//01 MEM hazard - Mem_Data
	else 
		Forward_A = 2'b00;  //no need forward
	end

always_comb
	begin
	if ((Reg_W_En_EXE2MEM) && (rd_EXE2MEM != 0) && (rd_EXE2MEM == rs2_ID2EXE) &&
	(Inst_ID2EXE[6:0] != `B_Type))
		Forward_B = 2'b10;	//10 EX hazard - ALURes_MEM
	else if ((Reg_W_En_MEM2WB) && (rd_MEM2WB != 0) && (rd_MEM2WB == rs2_ID2EXE) 
	&& (Inst_ID2EXE[6:0] != `B_Type))
		Forward_B = 2'b01;	//01 MEM hazard - Mem_Data
	else 
		Forward_B = 2'b00;  //no need forward
	end
	
always_comb
	begin
	if ((Reg_W_En_ID2EXE) && (rd_ID2EXE != 0) && (rd_ID2EXE == rs1_IF2ID) && 
	(Inst_IF2ID[6:0] == `B_Type))
		Forward_C = 2'b10;	//10 EX hazard - ALURes_MEM
	else if (Reg_W_En_EXE2MEM && (rd_EXE2MEM != 0) && (rd_EXE2MEM == rs1_IF2ID) && 
	(Inst_IF2ID[6:0] == `B_Type))
		Forward_C = 2'b01;	//01 MEM hazard - Mem_Data
	else 
		Forward_C = 2'b00;  //no need forward
	end

always_comb
	begin
	if (Reg_W_En_ID2EXE && (rd_ID2EXE != 0) && (rd_ID2EXE == rs2_IF2ID) && 
	(Inst_IF2ID[6:0] == `B_Type))
		Forward_D = 2'b10;	//10 EX hazard - ALURes_MEM
	else if (Reg_W_En_EXE2MEM && (rd_EXE2MEM != 0) && (rd_EXE2MEM == rs2_IF2ID) && 
	(Inst_IF2ID[6:0] == `B_Type))
		Forward_D = 2'b01;	//01 MEM hazard - Mem_Data
	else 
		Forward_D = 2'b00;  //no need forward
	end
endmodule
