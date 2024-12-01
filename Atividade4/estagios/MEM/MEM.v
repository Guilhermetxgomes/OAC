module MEM(
    input       clock,
    input       reset,
    // Sinais de controle WB
    input       mem_to_reg_in,
    input       reg_write_in,
    // Sinais de controle MEM
    input       mem_read_in,
    input       mem_write_in,
    input       beq_instruction_in,
    // Entrada de dados
    input [31:0] alu_result_in,
    input [31:0] mux2_result_in,
    input        flag_beq_in,
    // Enntrada do endereço do rd
    input [4:0] reg_rd_in,
    // Saída dos sinais de controle WB
    output      mem_to_reg_out,
    output      reg_write_out,
    // Saída do sinal pcSrc (instrução de branch)
    output      pcSrc,
    // Saída de dados e rd[addr]
    output [31:0] read_data_out,
    output [31:0] alu_result_out,
    output [4:0]  reg_rd_out,
    // Saída para forwading unit do estágio EX
    output [4:0] ex_mem_reg_rd,
    output       ex_mem_reg_write,
    output [31:0] alu_ex_mem
);

wire [31:0] data_out;

data_memory memoria_dados(
    .clk(clock), 
    .we(mem_write_in), // write enable
    .re(mem_read_in), // read enable
    .addr(alu_result_in), //valor que indica uma posição da memória
    .data_in(mux2_result_in),
    .data_out(data_out)
);

// lógica da instrução de branch
assign pcSrc = (beq_instruction_in && flag_beq_in) ? 1'b1 : 1'b0;

mem_wb_register mem_wb_reg(
    .clock(clock),
    .reset(reset),
    // Sinais de controle WB
    .mem_to_reg_in(mem_to_reg_in),
    .reg_write_in(reg_write_in),
    // Entrada de dados
    .read_data_in(data_out),
    .alu_result_in(alu_result_in),
    // Entrada do endereço do rd
    .reg_rd_in(reg_rd_in),
    // Saída dos sinais de controle WB
    .mem_to_reg_out(mem_to_reg_out),
    .reg_write_out(reg_write_out),
    // Saída de dados e rd[addr]
    .read_data_out(read_data_out),
    .alu_result_out(alu_result_out),
    .reg_rd_out(reg_rd_out)
);

// forwarding
assign alu_ex_mem = alu_result_in;
assign ex_mem_reg_write = reg_write_in;
assign ex_mem_reg_rd = reg_rd_in;

endmodule