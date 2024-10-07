//	    int A[3] = {0}; // Initialize all elements to 0
//	    int B = 1;
//	    for (int i = 0; i < 3; i++) {
//	        while (A[i] < x) {
//	            A[i] = A[i] * 2 + B; // Update A[i] based on B
//	            B = B << 1; // Left shift C by 1
//	        }

`include "constants.sv" 

module instructionMem (
    input logic nReset,
    input logic [`WORD_LEN-1:0] addr,
    output logic [`WORD_LEN-1:0] Instruction
);
  logic [$clog2(`INSTR_MEM_SIZE)-1:0] address;
  logic [`MEM_CELL_SIZE-1:0] instMem [0:`INSTR_MEM_SIZE-1];
  
  assign address [$clog2(`INSTR_MEM_SIZE)-1:0] = addr[$clog2(`INSTR_MEM_SIZE)-1:0];
 
	always_comb begin
		if (!nReset) begin
	    // No nop added in between instructions since there is a hazard detection unit
        // Initialize each byte of instruction memory on nReset
/*
        instMem[0] = 8'b11111111; //lw %1 %0 10'h3FF	 R1 = SW 
        instMem[1] = 8'b1111_0000;
        instMem[2] = 8'b0_010_0000;
        instMem[3] = 8'b1_0000011;
		
		instMem[4] = 8'b00000000; //addi %3 %0 1		(B)R3 = 1
        instMem[5] = 8'b0001_0000;
        instMem[6] = 8'b0_000_0001;
        instMem[7] = 8'b1_0010011;
		
		instMem[8] = 8'b00000000; //addi %5 %0 3		R5 = 3
        instMem[9] = 8'b0011_0000;
        instMem[10] = 8'b0_000_0010;
        instMem[11] = 8'b1_0010011;
		
		instMem[12] = 8'b0_000000_0; //BEQ %4 %5 20		if R4 = 3, PC = PC + 10
        instMem[13] = 8'b0101_0010;												   
        instMem[14] = 8'b0_000_1010_;//32'd20=			(19)0, 	   0,   0,  000000,    1010,  0
        instMem[15] = 8'b0_1100011;//B_Type: ImmG = {{19{[31]}}, [31], [7], [30:25], [11:8], 1'b0};
		
		instMem[16] = 8'b0_000000_0; //BLT %1 %2 10   	if R1 < R2, PC = PC + 5								 
        instMem[17] = 8'b0010_0000;
        instMem[18] = 8'b1_100_0101_;//32'd10 = 		(19)0,	  0,    0,   000000,  0101,  0
        instMem[19] = 8'b0_1100011;//B_Type: ImmG = {{19{[31]}}, [31], [7], [30:25], [11:8], 1'b0};
		
		instMem[20] = 8'b0000000_0; //SLLI %2 %2 1;		R2 = R2 << 1 
        instMem[21] = 8'b0001_0001;
        instMem[22] = 8'b0_001_0001;
        instMem[23] = 8'b0_0010011;
		
		instMem[24] = 8'b0000000_0; //ADD %2 %2 %3;		R2 = R3 + R2
        instMem[25] = 8'b0011_0001;
        instMem[26] = 8'b0_000_0001;
        instMem[27] = 8'b0_0110011;
		
		instMem[28] = 8'b0000000_0; //SLLI %3, %3, 1;		R3 = R3 << 1
        instMem[29] = 8'b0001_0001;
        instMem[30] = 8'b1_001_0001;
        instMem[31] = 8'b1_0010011;
		
		instMem[32] = 8'b1_1111111; //JUMP %0, -8;		PC += -4
        instMem[33] = 8'b100_1_1111; //00000000_00000000_00000000_00001000(8) -> (11)1_11111_11111111_11111000(-8)
        instMem[34] = 8'b1111_0000;//32'd-8 = 			(11)1,		1,	11111111,  1, 1111111100,0
        instMem[35] = 8'b0_1101111;//`J_Type: ImmG = {{11{[31]}}, [31], [19:12], [20], [30:21], 1'b0};
		
		instMem[36] = 8'b00000000; //ADDI %4, %4, 1;	R4 = R4 +1
        instMem[37] = 8'b0001_0010;
        instMem[38] = 8'b0_000_0010;
        instMem[39] = 8'b0_0010011;
		
		instMem[40] = 8'b0000000_0; //SW %4, %2, 0;	Mem [%4 + 0] = %2(A)
        instMem[41] = 8'b0010_0010;
        instMem[42] = 8'b0_010_0000;
        instMem[43] = 8'b0_0100011;
		
		instMem[44] = 8'b00000000; //ADDI %2, %0, 0; 	A = 0
        instMem[45] = 8'b0000_0000;
        instMem[46] = 8'b0_000_0001;
        instMem[47] = 8'b0_0010011;
		
		instMem[48] = 8'b1_1111110; //JUMP %0, -18;		PC += -9					  
        instMem[49] = 8'b111_1_1111;//00000000_00000000_00000000_00010010(18) -> (11)1_11111_11111111_11101110(-18)
        instMem[50] = 8'b1111_0000;//32'd-16 = 		(11)1, 			1, 11111111,  1,  1111110111,0
        instMem[51] = 8'b0_1101111;//`J_Type: ImmG = {{11{[31]}}, [31], [19:12], [20], [30:21], 1'b0};
		
		instMem[52] = 8'b1111111_0; //SW %0, %3, 10'h3FF; Mem [0 + 32'hFFFFFFFF] = %3(B)
        instMem[53] = 8'b0011_0000;
        instMem[54] = 8'b0_010_1111;
        instMem[55] = 8'b1_0100011;
		
		instMem[56] = 8'b00000000; //NOP
        instMem[57] = 8'b00000000;
        instMem[58] = 8'b00000000;
        instMem[59] = 8'b00000000;

		instMem[1023] = 8'b00000000;
	 */
	    instMem[0] = 8'b11111111; //lw %1 %0 10'h3FF	 R1 = SW 
        instMem[1] = 8'b1111_0000;
        instMem[2] = 8'b0_010_0000;
        instMem[3] = 8'b1_0000011;
		
		instMem[4] = 8'b0_000000_0;		// BLT %0, %1, 10		if R0 < R1, PC = PC + 5
		instMem[5] = 8'b0001_0000;
		instMem[6] = 8'b0_100_0101;		// 32'd10 = (19)0,          0,     0,   000000, 0101,     0
		instMem[7] = 8'b0_1100011;		// ImmG = {{19{[31]}}, [31], [7], [30:25], [11:8], 1'b0};
		end
	end
  assign Instruction = {instMem[address], instMem[address + 1], instMem[address + 2], instMem[address + 3]};
endmodule // insttructionMem
