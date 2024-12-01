module data_memory(
    input clk, 
    input we, // write enable
    input re, // read enable
    input [31:0] addr, //valor que indica uma posição da memória
    input [31:0] data_in,
    output [31:0] data_out
);

    reg [31:0] memory[0:255];

	integer i;
	initial begin 
		for (i = 0; i < 31; i = i + 1) begin //zerando posições de memória
			memory [i] = 32'd0;
		end
		memory[5] = 32'd8;
	    memory[6] = 32'd1; //definindo previamente uma posição de memória com valor para fins de teste
	end

    always @ (posedge clk) begin
        if (we == 1'b1) begin
            memory[addr] <= data_in;
        end
    end

    assign data_out = re ? memory[addr[7:0]] : 32'b0;

endmodule