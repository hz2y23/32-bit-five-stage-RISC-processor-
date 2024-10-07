// Pipeline register from Instruction Fetch Stage to Instruction Decode Stage
`include "constants.sv" 
module IF2ID (
    input logic clk,
    input logic nReset,
    input logic flush,
    input logic stall,
	input logic stall_twice,
    input logic [`WORD_LEN-1:0] PC_IN, 
	input logic [`WORD_LEN-1:0] PCplus4_IN, 
	input logic [`WORD_LEN-1:0] Instruction_IN,
    output logic [`WORD_LEN-1:0] PC, 
	output logic [`WORD_LEN-1:0] PCplus4, 
	output logic [`WORD_LEN-1:0] Instruction
);

    logic [1:0] count;
	
    always_ff @(posedge clk or negedge nReset) begin
        if (!nReset) begin// nReset 
            PC <= 0;
			PCplus4 <= 0;
            Instruction <= 0;
			count <= 0;
		end else if (flush) begin //flush clean
			PC <= 0;
			PCplus4 <= 0;
            Instruction <= 0;
			count <= 0;
		end else if (stall_twice || (count == 1)) begin  //stall twice only exis one clock cycle
		if (count == 2'b10) begin  // If already stalled for two cycles, reset count and proceed
                count <= 0;
                PC <= PC_IN;
				PCplus4 <= PCplus4_IN;
				Instruction <= Instruction_IN;
            end else begin  // Stall for two clock cycles
                count <= count + 1;
            end
        end else if (stall) begin
		    // Do nothing, keep the regOut value as it is
        end else begin
            PC <= PC_IN;
			PCplus4 <= PCplus4_IN;
			Instruction <= Instruction_IN;
			count <= 0;  // Reset the count when no stall_twice
		end
	end

	
endmodule // IF2ID
