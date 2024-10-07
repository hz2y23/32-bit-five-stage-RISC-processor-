module regFile #(
    parameter integer ADDR_LEN = 5,  // Number of bits for the register address
    parameter integer DATA_WIDTH = 32, // Data width of registers
    parameter integer REG_FILE_SIZE = 32 // Total number of registers
) (
    input logic clk,
    input logic nReset,
    input logic writeEn,
    input logic [ADDR_LEN-1:0] rs1, rs2, write_register,
    input logic [DATA_WIDTH-1:0] write_data,
    output logic [DATA_WIDTH-1:0] rd1, rd2
);

    logic [DATA_WIDTH-1:0] regMem [0:REG_FILE_SIZE-1]; // Register memory array
	//all registers are initialized to 0
    always_ff @(posedge clk or negedge nReset) begin
        if (!nReset) begin
            for (integer i = 0; i < REG_FILE_SIZE; i = i + 1)
                regMem[i] <= 0;
		end else if (writeEn && write_register != 0) begin  // Protect register 0 from being written to
            regMem[write_register] <= write_data;
			end
    end

    // Read data from registers
    assign rd1 = regMem[rs1];
    assign rd2 = regMem[rs2];

endmodule // regFile