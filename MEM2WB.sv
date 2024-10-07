// Pipeline register from Memory Stage to Write Back
`include "constants.sv" 

module MEM2WB (
    input logic clk, nReset,
	//control signal
    input logic Reg_W_En_IN,
	input logic [1:0] WBsel_IN,
	//register value
    input logic [`WORD_LEN-1:0] ALURes_IN, 
	input logic [`WORD_LEN-1:0] PCplus4_IN, 
	input logic [`WORD_LEN-1:0] Mem_Data_IN, 
	input logic [`WORD_LEN-1:0] Instruction_IN,
	//control signal
    output logic Reg_W_En, 
	output logic [1:0] WBsel,
	//register value
    output logic [`WORD_LEN-1:0] ALURes, 
	output logic [`WORD_LEN-1:0] PCplus4, 
	output logic [`WORD_LEN-1:0] Mem_Data,
	output logic [`WORD_LEN-1:0] Instruction
);

    always_ff @(posedge clk or negedge nReset) begin
        if (!nReset) begin
            Reg_W_En <= 0;
			WBsel <= 0;
			ALURes <= 0;
			PCplus4 <= 0;
			Mem_Data <= 0;
			Instruction <= 0;
        end else begin
            Reg_W_En <= Reg_W_En_IN;
            WBsel <= WBsel_IN;
            ALURes <= ALURes_IN;
            PCplus4 <= PCplus4_IN;
			Mem_Data <= Mem_Data_IN;
			Instruction <= Instruction_IN;
        end
    end
endmodule // MEM2WB
