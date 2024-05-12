
    /*        ZERO        */

`define		ZERO_32 		32'd0
`define     ZERO_7          7'd0
`define     ZERO_3          3'd0


`define		lui				7'b0110111
`define		auipc			7'b0010111
`define		jal				7'b1101111
`define		jalr			7'b1100111
`define		B_type			7'b1100011
`define		load			7'b0000011
`define		store			7'b0100011
`define		I_type			7'b0010011
`define		R_type			7'b0110011

`define 	ADD  			4'b0001
`define 	SUB  			4'b0011
`define 	SLL  			4'b1100
`define 	SLT  			4'b1001
`define 	SLTU 			4'b1000
`define 	XOR  			4'b0110
`define 	SRL  			4'b1101
`define 	SRA  			4'b1110
`define 	OR   			4'b0101
`define 	AND  			4'b0100


    /*        HARDWARE        */

`define		TUBE_SCAN		50000
`define     ZERO            8'b1111_1100
`define     ONE             8'b0110_0000
`define     TWO             8'b1101_1010
`define     THREE           8'b1111_0010
`define     FOUR            8'b0110_0110
`define     FIVE            8'b1011_0110
`define     SIX             8'b1011_1110
`define     SEVEN           8'b1110_0000
`define     EIGHT           8'b1111_1110
`define     NINE            8'b1111_0110
`define     A               8'b1110_1110
`define     B               8'b0011_1110
`define     C               8'b1001_1100
`define     D               8'b0111_1010
`define     E               8'b1001_1110
`define     F               8'b1001_0110