module mux_input #(
    parameter integer WIDTH = 32
) (
    input logic [WIDTH-1:0] ALURes,
    input logic [WIDTH-1:0] in1, 
	input logic [WIDTH-1:0] in2,
    output logic [WIDTH-1:0] out
);
	always_comb
		begin
		if (ALURes == 32'hFFFFFFFF)
			out = in2;
		else
			out = in1;
		end

endmodule // mux
