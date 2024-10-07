`include "constants.sv" 

module MemoryStage (
    input logic clk,
    input logic nReset,
	//control signal
    input logic Mem_R_En,
    input logic Mem_W_En,
	input logic Reg_W_En_IN,
	input logic [1:0] WBsel_IN,
	//register value
    input logic [`WORD_LEN-1:0] ALURes_IN,
	input logic [`WORD_LEN-1:0] PCplus4_IN,
    input logic [`WORD_LEN-1:0] rd2,
	input logic [`WORD_LEN-1:0] Instruction_IN,
	//input
	input logic [`WORD_LEN-1:0] SW,
	//output
	output logic [`WORD_LEN-1:0] LED,
	//control signal
	output logic Reg_W_En,
	output logic [1:0] WBsel,
	//register value
	output logic [`WORD_LEN-1:0] Mem_Data_or_SW,
	output logic [`WORD_LEN-1:0] ALURes, 
	output logic [`WORD_LEN-1:0] PCplus4,
	output logic [`WORD_LEN-1:0] Instruction

);	
	logic [`WORD_LEN-1:0] Mem_Data;
	
	assign regLED_W_En = (Mem_W_En && (ALURes_IN == 32'hFFFFFFFF))? 1:0;
	
	register #(.WIDTH(`WORD_LEN)) regLED (
		.clk(clk),
		.nReset(nReset),
		.WriteEn(regLED_W_En),
		.regIn(rd2),
		.regOut(LED)
	);
	
    // Data Memory
    DataMemory #(
    .DATA_WIDTH(`WORD_LEN),  
    .ADDR_WIDTH(10),  
    .MEM_SIZE(`DATA_MEM_SIZE) 
	)data_memory (
        .clk(clk),
        .nReset(nReset),
        .Mem_W_En(Mem_W_En),
        .Mem_R_En(Mem_R_En),
        .address(ALURes_IN[9:0]),
        .writeData(rd2),
        .readData(Mem_Data)
    );
	
	// mux for input
    mux_input #(.WIDTH(`WORD_LEN)) mux1 (
        .in1(Mem_Data),
        .in2(SW),
        .ALURes(ALURes_IN),
        .out(Mem_Data_or_SW)
    );
	
	assign PCplus4 = PCplus4_IN;
	assign Instruction = Instruction_IN;
	assign WBsel = WBsel_IN;
	assign Reg_W_En = Reg_W_En_IN;
	assign ALURes = ALURes_IN;

endmodule // MemoryStage

