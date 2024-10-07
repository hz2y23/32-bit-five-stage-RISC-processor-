`include "constants.sv" 

module WBStage (
	input logic [1:0]WBsel,          
	input logic [`WORD_LEN-1:0] Mem_Data,
    input logic [`WORD_LEN-1:0] PCplus4,  //JAL	
    input logic [`WORD_LEN-1:0] ALURes,
    output logic [`WORD_LEN-1:0] WB_result 
);

    // Select data source for write-back stage
	mux_3input #(.WIDTH(`WORD_LEN)) wbmux (
		.in1(ALURes),
		.in2(Mem_Data),
		.in3(PCplus4),
		.sel(WBsel),
		.out(WB_result)
	);

endmodule // WBStage
