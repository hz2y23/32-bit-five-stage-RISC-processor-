
module DataMemory #(
    parameter integer DATA_WIDTH = 32,  
    parameter integer ADDR_WIDTH = 10,  
    parameter integer MEM_SIZE = 1024 
) (
    input logic clk,
    input logic nReset,
    input logic Mem_W_En,
    input logic Mem_R_En,
    input logic [ADDR_WIDTH-1:0] address,
    input logic [DATA_WIDTH-1:0] writeData,
    output logic [DATA_WIDTH-1:0] readData
);

    logic [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1]; // Memory array
	
    always_ff @(posedge clk, negedge nReset) begin
        if (!nReset) begin
            for (integer i = 0; i < MEM_SIZE; i++) begin
                memory[i] <= 0;
            end
        end else if (Mem_W_En) begin
            memory[address] <= writeData;  // Write data to memory
        end
    end

    // Memory read operation
    always_ff @(posedge clk) begin
        if (Mem_R_En) begin
            readData <= (address < MEM_SIZE) ? memory[address] : 0;
        end
    end

endmodule // DataMemory

