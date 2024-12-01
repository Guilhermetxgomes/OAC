module alu (
	input   [31:0] a, 
    input   [31:0] b,
	input   [3:0 ] op, 
	output  [31:0] res, 
	output         flag
);  

    // Lista de operações
    // op = 0010 : add
    // op = 0110 : sub
    // op = 0000 : and
    // op = 0001 : or

	assign res = (op == 4'b0010) ? a + b :          // add
                 (op == 4'b0110) ? a + ((~b) + 1) : // sub
				 (op == 4'b0000) ? a & b :          // and
                 (op == 4'b0001) ? a | b : 32'd0;   // or

    assign flag = (res == 32'd0) ? 1 : 0; // beq

endmodule