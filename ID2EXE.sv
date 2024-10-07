// Pipeline register from Instruction Decode Stage to Execute Stage
`include "constants.sv" 
module ID2EXE (
    input logic clk, nReset,
	input logic flush, 
	input logic stall,
	input logic stall_twice,
    input logic Mem_R_En_IN, 
	input logic Mem_W_En_IN, 
	input logic Reg_W_En_IN, 
	input logic BranchTK_IN, 
	input logic Imsel_IN,
    input logic [1:0] ALUOp_IN,
	input logic [1:0] WBsel_IN,
    input logic [`WORD_LEN-1:0] rd1_IN,
	input logic [`WORD_LEN-1:0] rd2_IN,
	input logic [`WORD_LEN-1:0] ImmG_IN,
	input logic [`WORD_LEN-1:0] PC_IN,
	input logic [`WORD_LEN-1:0] PCplus4_IN,
	input logic [`WORD_LEN-1:0] Instruction_IN,
    output logic Mem_R_En, 
	output logic Mem_W_En, 
	output logic Reg_W_En, 
	output logic BranchTK, 
	output logic Imsel, 
	output logic [1:0] ALUOp,
	output logic [1:0] WBsel,
    output logic [`WORD_LEN-1:0] rd1,
	output logic [`WORD_LEN-1:0] rd2, 
	output logic [`WORD_LEN-1:0] ImmG, 
	output logic [`WORD_LEN-1:0] PC, 
	output logic [`WORD_LEN-1:0] PCplus4, 
	output logic [`WORD_LEN-1:0] Instruction
);

    logic [1:0] count;
	
    always_ff @(posedge clk or negedge nReset) begin
        if (!nReset) begin
			Mem_R_En <= 0;
            Mem_W_En <= 0;
            Reg_W_En <= 0;
            BranchTK <= 0;
			Imsel <= 0;
			ALUOp <= 0;
			WBsel <= 0;
			rd1 <= 0;
			rd2 <= 0;
            ImmG <= 0;
            PC <= 0;
			PCplus4 <= 0;
			Instruction <= 0;
			count <= 0;
		end else if (flush) begin
			Mem_R_En <= 0;
            Mem_W_En <= 0;
            Reg_W_En <= 0;
            BranchTK <= 0;
			Imsel <= 0;
			ALUOp <= 0;
			WBsel <= 0;
			rd1 <= 0;
			rd2 <= 0;
            ImmG <= 0;
            PC <= 0;
			PCplus4 <= 0;
			Instruction <= 0;
			count <= 0; 
		end else if (stall_twice || (count == 2'b01) || (count == 2'b10)) begin  //clesn transfer clean
            if (count == 2'b01) begin  // stall once
                count <= count + 1;
                Mem_R_En <= Mem_R_En_IN;
				Mem_W_En <= Mem_W_En_IN;
				Reg_W_En <= Reg_W_En_IN;
				BranchTK <= BranchTK_IN;
				Imsel <= Imsel_IN;
				ALUOp <= ALUOp_IN;
				WBsel <= WBsel_IN;
				rd1 <= rd1_IN;
				rd2 <= rd2_IN;
				ImmG <= ImmG_IN;
				PC <= PC_IN;
				PCplus4 <= PCplus4_IN;
				Instruction <= Instruction_IN;
            end else begin  // transfer twice
				Mem_R_En <= 0;
				Mem_W_En <= 0;
				Reg_W_En <= 0;
				BranchTK <= 0;
				Imsel <= 0;
				ALUOp <= 0;
				WBsel <= 0;
				rd1 <= 0;
				rd2 <= 0;
				ImmG <= 0;
				PC <= 0;
				PCplus4 <= 0;
				Instruction <= 0;
                count <= count + 1;
            end
        end else if (stall) begin
            Mem_R_En <= 0;
            Mem_W_En <= 0;
            Reg_W_En <= 0;
            BranchTK <= 0;
			Imsel <= 0;
			ALUOp <= 0;
			WBsel <= 0;
			rd1 <= 0;
			rd2 <= 0;
            ImmG <= 0;
            PC <= 0;
			PCplus4 <= 0;
			Instruction <= 0;
			count <= 0;
        end else begin
            // No stall, update the register value
            Mem_R_En <= Mem_R_En_IN;
			Mem_W_En <= Mem_W_En_IN;
			Reg_W_En <= Reg_W_En_IN;
			BranchTK <= BranchTK_IN;
			Imsel <= Imsel_IN;
			ALUOp <= ALUOp_IN;
			WBsel <= WBsel_IN;
			rd1 <= rd1_IN;
			rd2 <= rd2_IN;
			ImmG <= ImmG_IN;
			PC <= PC_IN;
			PCplus4 <= PCplus4_IN;
			Instruction <= Instruction_IN;
            count <= 0;  // Reset the count when no stall_twice
        end
    end
        
endmodule // ID2EXE
