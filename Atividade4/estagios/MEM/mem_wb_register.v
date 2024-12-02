module mem_wb_register (
    input       clock,
    input       reset,
    // Sinais de controle WB
    input       mem_to_reg_in,
    input       reg_write_in,
    // Entrada de dados
    input [31:0] read_data_in,
    input [31:0] alu_result_in,
    // Entrada do endereço do rd
    input [4:0] reg_rd_in,
    // Saída dos sinais de controle WB
    output      mem_to_reg_out,
    output      reg_write_out,
    // Saída de dados e rd[addr]
    output [31:0] read_data_out,
    output [31:0] alu_result_out,
    output [4:0]  reg_rd_out
);

reg mem_to_reg_value;
reg [31:0] reg_write_value;
reg [31:0] read_data_value;
reg [31:0] alu_result_value;
reg [4:0] reg_rd_value;

    always @(posedge clock) begin
        if(reset) begin
            mem_to_reg_value <= 1'b0;
            reg_write_value <= 32'd0;
            read_data_value <= 32'd0;
            alu_result_value <= 32'd0;
            reg_rd_value <= 5'd0;
        end else begin
            mem_to_reg_value <= mem_to_reg_in;
            reg_write_value <= reg_write_in;
            read_data_value <= read_data_in;
            alu_result_value <= alu_result_in;
            reg_rd_value <= reg_rd_in;
        end
    end

assign mem_to_reg_out = mem_to_reg_value;
assign reg_write_out = reg_write_value;
assign read_data_out = read_data_value;
assign alu_result_out = alu_result_value;
assign reg_rd_out = reg_rd_value;

endmodule
