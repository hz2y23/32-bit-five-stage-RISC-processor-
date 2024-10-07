//-----------------------------------------------------
// File Name : branch.sv
// Function : Branch comparator module
// Author: zhy
// Last rev. 8 Jun 24
//-----------------------------------------------------
module branch #(parameter WIDTH =32) (
	input logic [WIDTH-1:0] a, b,
	input logic BranchEn,
	input logic [2:0] func3,
	output logic BEQ, BNE, BLT, BGE  // comparison result
);
	
// Calculate BEQ, BNE, BLT, BGE
always_comb
	begin
	BEQ = 0; BNE = 0; BLT = 0; BGE = 0;
	case(func3)
		3'b000: BEQ = ((a == b) && (BranchEn)) ? 1 : 0;
		3'b001: BNE = ((a != b) && (BranchEn)) ? 1 : 0;
		3'b100: BLT = ((a < b) && (BranchEn)) ? 1 : 0;
		3'b101: BGE = ((a >= b) && (BranchEn)) ? 1 : 0;
		default begin BEQ = 0; BNE = 0; BLT = 0; BGE = 0; end
	endcase
	end
	
endmodule