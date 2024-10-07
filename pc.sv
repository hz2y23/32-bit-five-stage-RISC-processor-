

module pc #(
    parameter integer WIDTH = 32  // bit-width of the register
) (
    input logic clk,
    input logic nReset,
    input logic stall,
    input logic stall_twice,
    input logic [WIDTH-1:0] regIn,
    output logic [WIDTH-1:0] regOut
);

    // Add a counter for stall_twice mechanism
    logic [1:0] count;

    always_ff @(posedge clk or negedge nReset) begin
        if (!nReset) begin
            regOut <= 0;
            count <= 0;
        end else if (stall_twice || (count == 1)) begin  //stall twice only exis one clock cycle
            if (count == 2'b10) begin  // If already stalled for two cycles, reset count and proceed
                count <= 0;
                regOut <= regIn;
            end else begin  // Stall for two clock cycles
                count <= count + 1;
            end
        end else if (stall) begin
            // Do nothing, keep the regOut value as it is
        end else begin
            // No stall, update the register value
            regOut <= regIn;
            count <= 0;  // Reset the count when no stall_twice
        end
    end

endmodule // pc


















