
module WB(
    input       clock,
    input       reset,
    // Sinais de controle WB
    input       reg_write_in,
    input       mem_to_reg_in,
    // Entrada de dados
    input [31:0] read_data_in,
    input [31:0] alu_result_in,
    input [4:0] reg_rd_in,
    // Saida de dados
    output [31:0] alu_data_mem_wb,
    // Saida para forwarding unit do estagio EX
    output [4:0] reg_rd_out,
    output reg_write_out
);

    mux_2_values #(
        .WIDTH(32)
    ) mux_write_back (
        .sel(mem_to_reg_in),
        .D0(alu_result_in),
        .D1(read_data_in),
        .D_out(alu_data_mem_wb)
    );

    assign reg_rd_out = reg_rd_in;
    assign reg_write_out = reg_write_in;

endmodule