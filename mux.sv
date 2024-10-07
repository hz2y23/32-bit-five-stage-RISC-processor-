module mux #(
    parameter integer WIDTH = 32
) (
    input logic sel,
    input logic [WIDTH-1:0] in1, in2,
    output logic [WIDTH-1:0] out
);

    assign out = sel ? in2 : in1;

endmodule // mux
