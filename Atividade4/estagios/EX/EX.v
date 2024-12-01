module EX (
    input       clock,
    input       reset,
    // Sinais de entrada de dados
    input [31:0] reg_a_in,
    input [31:0] reg_b_in,
    // Sinais de controle WB
    input       mem_to_reg_in,
    input       reg_write_in,
    // Sinais de controle MEM
    input       mem_read_in,
    input       mem_write_in,
    input       beq_instruction_in,
    // Sinais de controle EX
    input       aluSrc_in,
    input [1:0] aluOp_in,
    // Demais entradas de registrados e imediato
    input [6:0] funct7_in,
    input [2:0] funct3_in,
    input [4:0] reg_rs1_in,
    input [4:0] reg_rs2_in,
    input [4:0] reg_rd_in,
    input [31:0] immediate_in,
    // Sinais de entrada para o forwarding
    input [4:0] ex_mem_reg_rd,
    input       ex_mem_reg_write,
    input [4:0] mem_wb_reg_rd,
    input       mem_wb_reg_write,
    // Saídas sinais de controle WB
    output      mem_to_reg_out,
    output      reg_write_out,
    // Saídas sinais de controle MEM
    output      mem_read_out,
    output      mem_write_out,
    output      beq_instruction_out,
    // Saídas do banco de registradores EX/MEM
    output [31:0] alu_result_out,
    output [31:0] mux2_result_out,
    output [4:0] reg_rd_out
);


wire [3:0 ] op_alu;
wire [31:0] mux1_out;
wire [31:0] mux2_out;
wire        flag_beq;
wire        forwardA;
wire        forwardB;

mux_3_values #(
   .WIDTH(32)
) mux1 (
    .sel(forwardA),
    .D0(reg_a_in),
    .D1(alu_ex_mem),
    .D2(alu_data_mem_wb),
    .D_out(mux1_out)
);

mux_3_values #(
   .WIDTH(32)
) mux2 (
    .sel(forwardB),
    .D0(reg_b_in),
    .D1(alu_ex_mem),
    .D2(alu_data_mem_wb),
    .D_out(mux2_out)
);

mux_2_values #(
    .WIDTH(32)
  ) mux3 (
    .sel(aluSrc),
    .D0(mux2_out),
    .D1(immediate_in),
    .D_out(mux3_out)
  );

alu alu_ex(
	.a(mux1_out), 
    .b(mux3_out),
	.op(op_alu), 
	.res(alu_result), 
	.flag(flag_beq)
);  

alu_control alu_control_ex(
    .aluOp(aluOp_in)
    .funct7(funct7_in),
    .funct3(funct3_in),
    .op(op_alu)
);

forwarding_unit forward(
    .id_ex_reg_rs1(reg_rs1_in),
    .id_ex_reg_rs2(reg_rs2_in),
    .ex_mem_reg_write(ex_mem_reg_write),
    .ex_mem_reg_rd(ex_mem_reg_rd),
    .mem_wb_reg_write(mem_wb_reg_write),
    .mem_wb_reg_rd(mem_wb_reg_rd),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

ex_mem_register (
    .clock(clock),
    .reset(reset),
    // Sinais de controle WB
    .mem_to_reg_in(mem_to_reg_in),
    .reg_write_in(reg_write_in),
    // Sinais de controle MEM
    .mem_read_in(mem_read_in),
    .mem_write_in(mem_write_in),
    .beq_instruction_in(beq_instruction_in),
    // Sinais de dados
    .alu_result_in(alu_result),
    .mux2_result_in(mux2_out),
    .reg_rd_in(reg_rd_in),
    .flag_beq_in(flag_beq),
    // Saídas sinais de controle WB
    .mem_to_reg_out(mem_to_reg_out),
    .reg_write_out(reg_write_out),
    // Saídas sinais de controle MEM
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .beq_instruction_out(beq_instruction_out),
    // Saídas do banco de registradores EX/MEM
    .alu_result_out(alu_result_out),
    .mux2_result_out(mux2_result_out),
    .reg_rd_out(reg_rd_out),
    .flag_beq_out(flag_beq_out)
);

endmodule