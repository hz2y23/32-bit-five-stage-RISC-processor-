`include "alucodes.sv"
 module ALUControl(
    input [1:0] ALUOp,        
    input [6:0] funct7, 
    input [2:0] funct3,  
    output reg [3:0] EXE_CMD 
);

    always @(*) begin
        case (ALUOp)
            2'b00: begin //Rtype/Itypr_calculation
                case(funct3)
                    3'b000: begin 
								if (funct7 == 7'b0000000)
									EXE_CMD = `EXE_ADD;
								else if (funct7 == 7'b0100000)
									EXE_CMD = `EXE_SUB;
							end
                    3'b001: EXE_CMD = `EXE_SLL;
                    3'b010: EXE_CMD = `EXE_SLT;
                    3'b100: EXE_CMD = `EXE_XOR;
                    3'b101: begin 
								if (funct7 == 7'b0000000)
									EXE_CMD = `EXE_SRL;
								else if (funct7 == 7'b0100000)
									EXE_CMD = `EXE_SRA;
							end
                    3'b110: EXE_CMD = `EXE_OR;
                    3'b111: EXE_CMD = `EXE_AND;
                    default: EXE_CMD = `EXE_AND;
                endcase
            end
			2'b01: EXE_CMD = `EXE_ADD; //Load/Store
            2'b10: EXE_CMD = `EXE_LUI; //LUI
            default: EXE_CMD = `EXE_ADD;
        endcase
    end

endmodule