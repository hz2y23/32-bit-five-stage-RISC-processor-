// Pipeline register from Execute Stage to Memory Stage
`include "constants.sv" 

module EXE2MEM (
    input logic clk, 
	input logic nReset,
	input logic stall_twice,
	//control signal
    input logic Reg_W_En_IN, 
	input logic Mem_R_En_IN, 
	input logic Mem_W_En_IN, 
	input logic [1:0] WBsel_IN,
	//register value
    input logic [`WORD_LEN-1:0] rd2_IN,
    input logic [`WORD_LEN-1:0] PCplus4_IN, 
	input logic [`WORD_LEN-1:0] ALURes_IN,
	input logic [`WORD_LEN-1:0] Instruction_IN,
	//control signal
    output logic Reg_W_En, 
	output logic Mem_R_En, 
	output logic Mem_W_En, 
	output logic [1:0] WBsel,
	//register value
    output logic [`WORD_LEN-1:0] rd2,
    output logic [`WORD_LEN-1:0] PCplus4, 
	output logic [`WORD_LEN-1:0] ALURes,
	output logic [`WORD_LEN-1:0] Instruction
);

	logic [1:0] count;
  // Using always_ff for flip-flops (sequential logic)
  always_ff @(posedge clk or negedge nReset) begin
    if (!nReset) begin
		Reg_W_En <= 0;
		Mem_R_En <= 0;
		Mem_W_En <= 0;
		WBsel <= 0;
		rd2 <= 0;
		PCplus4 <= 0;
		ALURes <= 0;
		Instruction <= 0;
		count <= 0;
		end else if (stall_twice || (count == 2'b01) || (count == 2'b10)) begin  //transfer clean transfer
            if (count == 2'b01) begin  // stall once
                count <= count + 1;
                Reg_W_En <= 0;
				Mem_R_En <= 0;
				Mem_W_En <= 0;
				WBsel <= 0;
				rd2 <= 0;
				PCplus4 <= 0;
				ALURes <= 0;
				Instruction <= 0;
            end else begin  // transfer twice
				Reg_W_En <= Reg_W_En_IN;
				Mem_R_En <= Mem_R_En_IN;
				Mem_W_En <= Mem_W_En_IN;
				WBsel <= WBsel_IN;
				rd2 <= rd2_IN;
				PCplus4 <= PCplus4_IN;
				ALURes <= ALURes_IN;
				Instruction <= Instruction_IN;
                count <= count + 1;
            end
	end else begin
		Reg_W_En <= Reg_W_En_IN;
		Mem_R_En <= Mem_R_En_IN;
		Mem_W_En <= Mem_W_En_IN;
		WBsel <= WBsel_IN;
		rd2 <= rd2_IN;
		PCplus4 <= PCplus4_IN;
		ALURes <= ALURes_IN;
		Instruction <= Instruction_IN;
	end
end
endmodule // EXE2MEM
