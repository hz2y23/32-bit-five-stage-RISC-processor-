 `include "opcodes.sv"
module ImmGen #(parameter WIDTH = 32) (
    input logic [WIDTH-1:0] Instruction,
    output logic [WIDTH-1:0] ImmG);


always_comb
    case(Instruction[6:0])
        `I_Type_Load: ImmG = {{20{Instruction[WIDTH-1]}}, Instruction[WIDTH-1:20]};
        `I_Type_calculate: 
		begin
		if ((Instruction[14:12] == 3'b101) || (Instruction[14:12] == 3'b001)) //SRAI/SLLI/SRLI
			ImmG = {28'b0, Instruction[24:20]};
		else
			ImmG = {{20{Instruction[WIDTH-1]}}, Instruction[WIDTH-1:20]};
		end
        `S_Type: ImmG = {{20{Instruction[WIDTH-1]}}, Instruction[WIDTH-1:25], Instruction[11:7]};
        `B_Type: ImmG = {{19{Instruction[WIDTH-1]}}, Instruction[WIDTH-1], Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};
        `JAL: 	 ImmG = {{11{Instruction[WIDTH-1]}}, Instruction[WIDTH-1], Instruction[19:12], Instruction[20], Instruction[30:21], 1'b0};
        `LUI: 	 ImmG = {Instruction[WIDTH-1:12], 12'b0};
        default:                     
            ImmG = {32'b0};

    endcase
    
endmodule
