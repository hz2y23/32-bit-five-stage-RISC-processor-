`include "opcodes.sv"  
module controller(
    
    //Input
    input logic [6:0] Opcode, 
    input logic BEQ, BNE, BLT, BGE,
    //Outputs
    output logic Imsel,
    output logic BranchEn, 
    output logic Reg_W_En,
    output logic Mem_R_En, 
	output logic Mem_W_En, 
    output logic [1:0] ALUOp,//00:Rtype/Itype_calculation; 01:LW/SW; 10: LUI; 
    output logic BranchTK,
    output logic [1:0] WBsel//00：ALURes; 01: mem_Data; 10: PC+4(JAL);
);
always_comb begin
	Imsel = 0; 
	BranchEn = 0; 
	Reg_W_En = 0; 
	Mem_R_En = 0; 
	Mem_W_En = 0; 
	ALUOp [1:0] = 0; 
	BranchTK = 0;  
	WBsel[1:0] = 0;
	case (Opcode)
	`R_Type: begin 
		Reg_W_En = 1; 
		end
		
	`I_Type_Load: begin
		Reg_W_En = 1; 
		Mem_R_En = 1;
		Imsel = 1;
		ALUOp [1:0] = 2'b01; 
		WBsel[1:0] = 2'b01;
		end
		
	`S_Type: begin
		Mem_W_En = 1;
		Imsel = 1;
		ALUOp [1:0] = 2'b01; 
		end
		
	`I_Type_calculate: begin
		Reg_W_En = 1;
		Imsel = 1;
		end
		
	`B_Type: begin
		BranchEn = 1;
		if( BEQ || BNE || BLT || BGE)
			BranchTK = 1;
		end
		
	`JAL: begin
		Reg_W_En = 1;
		BranchTK = 1;
		WBsel[1:0] = 2'b10;
		end
	
	`LUI: begin
		Reg_W_En = 1;
		ALUOp [1:0] = 2'b10; 
		end
	default:begin
		Imsel = 0; 
		BranchEn = 0; 
		Reg_W_En = 0; 
		Mem_R_En = 0; 
		Mem_W_En = 0; 
		ALUOp [1:0] = 0; 
		BranchTK = 0;  
		WBsel[1:0] = 0;
		end
	endcase
end
endmodule
