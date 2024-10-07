`include "alucodes.sv"
module alu#(
        parameter WIDTH = 32,
        parameter LENGTH = 4
        )
        (input logic [WIDTH-1:0] aluA,
        input logic [WIDTH-1:0] aluB,

        input logic [LENGTH-1:0] EXE_CMD,
        output logic[WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(EXE_CMD)
            `EXE_ADD: ALUResult = aluA + aluB;
            `EXE_OR:  ALUResult = aluA | aluB;
            `EXE_AND: ALUResult = aluA & aluB;
            `EXE_XOR: ALUResult = aluA ^ aluB;
            `EXE_SLL: ALUResult = aluA << aluB;
            `EXE_SRL: ALUResult = aluA >> aluB;
            `EXE_SUB: ALUResult = aluA - aluB;
            `EXE_SRA: ALUResult = aluA >>> aluB;
			`EXE_SLT: ALUResult = (aluA < aluB)? 1:0;
			`EXE_LUI: ALUResult = aluB;
            default: ALUResult = 0;
            endcase
        end
endmodule

