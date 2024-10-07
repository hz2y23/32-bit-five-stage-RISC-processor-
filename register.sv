
module register #(
    parameter integer WIDTH = 32
) (
    input logic clk,
    input logic nReset,
	input logic WriteEn,
    input logic [WIDTH-1:0] regIn,
    output logic [WIDTH-1:0] regOut
);
	logic stall_counter, transfer1, transfer2;
	
    always_ff @(posedge clk or negedge nReset) begin
        if (!nReset)
            regOut <= '0;
        else if (WriteEn)
            regOut <= regIn;  // Write new value if enabled
	end

endmodule // register


















