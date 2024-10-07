`include "opcodes.sv" 
module Hazard_Detection
    (input logic [4:0] rs1_IF2ID,
     input logic [4:0] rs2_IF2ID,
     input logic [4:0] rd_ID2EXE,
     input logic Mem_R_En_ID2EXE,
	 input logic BranchTK_ID,
	 input logic Reg_W_En_ID2EXE,
	 input logic [6:0] Opcode_IF2ID,
	 input logic [6:0] Opcode_ID2EXE,
     output logic stall,
	 output logic stall_twice
    );
	//Mem_W_En_ID2EXE
always_comb
	begin
		if ((Mem_R_En_ID2EXE && (!BranchTK_ID) && ((rd_ID2EXE == rs1_IF2ID) || ((rd_ID2EXE == rs2_IF2ID) && 
		((Opcode_IF2ID == `R_Type) || (Opcode_IF2ID == `B_Type) || (Opcode_IF2ID == `S_Type))))))
			stall = 1;
		else
			stall = 0;
	end
	
always_comb
	begin
		if (Mem_R_En_ID2EXE && BranchTK_ID && ((rd_ID2EXE == rs1_IF2ID) || ((rd_ID2EXE == rs2_IF2ID) )))
			stall_twice = 1;
		else
			stall_twice = 0;
	end

endmodule
