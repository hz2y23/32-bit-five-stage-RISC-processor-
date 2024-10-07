module mux_3input #(
    parameter integer WIDTH = 32
) (
    input logic [1:0] sel,
    input logic [WIDTH-1:0] in1, in2, in3,
    output logic [WIDTH-1:0] out
);

    always_comb begin
        case (sel)
            2'd0: out = in1;
            2'd1: out = in2;
            2'd2: out = in3;
            default: out = in1;
        endcase
    end

endmodule // mux_3input
