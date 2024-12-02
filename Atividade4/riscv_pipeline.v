module riscv_pipeline(
    input clock,
    input reset
);

// Sinais internos IF->ID
wire [31:0] s_instruction;
wire [31:0] s_pc_value;

// Sinais internos ID->IF
wire [31:0] s_pc_branch_value;
wire        s_load_pc;
wire        s_load_if_id_register;
wire        s_IF_flush;
wire        s_mux_IF;

// Sinais internos ID->EX
wire        s_mem_to_reg_id_ex;
wire        s_reg_write_id_ex;
wire        s_mem_read_id_ex;
wire        s_mem_write_id_ex;
wire        s_beq_instruction_id_ex;
wire        s_aluSrc;
wire [1:0]  s_aluOp;
wire [6:0]  s_funct7;
wire [2:0]  s_funct3;
wire [4:0]  s_addr_rs1;
wire [4:0]  s_addr_rs2;
wire [4:0]  s_addr_rsd_id_ex;
wire [31:0] s_immediate;
wire [31:0] s_reg_a;
wire [31:0] s_reg_b;

// Sinais internos EX->ID
wire [4:0]  s_rd_ex;

// Sinais internos EX->MEM
wire        s_mem_to_reg_ex_mem;
wire        s_reg_write_ex_mem;
wire        s_mem_read_ex_mem;
wire        s_mem_write_ex_mem;
wire        s_beq_instruction_ex_mem;
wire [31:0] alu_result_ex_mem;
wire [31:0] mux2_result_ex_mem;
wire [4:0]  reg_rd_ex_mem;
wire        flag_beq_ex_mem;

// Sinais internos MEM->EX (forwading)
wire [4:0]  forward_ex_mem_reg_rd;
wire        forward_ex_mem_reg_write;
wire [31:0] forward_alu_ex_mem;

// Sinais internos MEM->IF
wire        s_pcSrc;

// Sinais internos MEM->WB
wire [31:0] s_read_data_mem_wb;
wire [31:0] s_alu_result_mem_wb;
wire [4:0]  s_reg_rb_mem_wb;
wire        s_mem_to_reg_mem_wb;
wire        s_reg_write_mem_wb;

// Sinais internos WB->EX
wire [4:0]  forward_mem_wb_reg_rd;
wire        forward_mem_wb_reg_write;

// Sinais internos WB->ID
wire [31:0] s_alu_data_mem_wb;


fetch IF_stage(
    .clock(clock),
    .reset(reset),
    .pc_branch_value(s_pc_branch_value),
    .mux_sel(s_mux_IF),
    .load_pc(s_load_pc),
    .load_if_id_register(s_load_if_id_register),
    .if_flush(s_IF_flush)

    .pc_out(s_pc_value),
    .instrucao(s_instruction)
);

decode ID_stage(
    .clock(clock),
    .reset(reset),
    .write_enable(forward_mem_wb_reg_write),
    .instruction(s_instruction),
    .pc(s_pc_value),
    .Din(s_alu_data_mem_wb),
    .dest_ex_mem(reg_rd_ex_mem),
    .dest_mem_wb(forward_mem_wb_reg_rd), 
    .reg_destino_exe(forward_mem_wb_reg_rd),

    .pc_enable(s_load_pc), 
    .if_id_enable(s_load_if_id_register),
    .mem_to_reg_out(s_mem_to_reg_id_ex), 
    .reg_write_out(s_reg_write_id_ex), 
    .mem_read_out(s_mem_read_id_ex),
    .mem_write_out(s_mem_write_id_ex), 
    .beq_instruction_out(s_beq_instruction_id_ex), 
    .aluSrc_out(s_aluSrc),
    .aluOp_out(s_aluOp),
    .rs1_out(s_addr_rs1), 
    .rs2_out(s_addr_rs2), 
    .rd_out(s_addr_rsd_id_ex),
    .imediato_out(s_immediate), 
    .pc_branch_value(s_pc_branch_value),
    .reg_a_out(s_reg_a),
    .reg_b_out(s_reg_b),
    .funct7_out(s_funct7),
    .funct3_out(s_funct3),
    .IF_flush(s_IF_flush),
    .mux_sel_IF(s_mux_IF)
);

EX EX_stage(
    .clock(clock),
    .reset(reset),
    // Sinais de entrada de dados
    .reg_a_in(s_reg_a),
    .reg_b_in(s_reg_b),
    // Sinais de controle WB
    .mem_to_reg_in(s_mem_to_reg_id_ex),
    .reg_write_in(s_reg_write_id_ex),
    // Sinais de controle MEM
    .mem_read_in(s_mem_read_id_ex),
    .mem_write_in(s_mem_write_id_ex),
    .beq_instruction_in(s_beq_instruction_id_ex),
    // Sinais de controle EX
    .aluSrc_in(s_aluSrc),
    .aluOp_in(s_aluOp),
    // Demais entradas de registrados e imediato
    .funct7_in(s_funct7),
    .funct3_in(s_funct3),
    .reg_rs1_in(s_addr_rs1),
    .reg_rs2_in(s_addr_rs2),
    .reg_rd_in(s_addr_rsd_id_ex),
    .immediate_in(s_immediate),
    // Sinais de entrada para o forwarding
    .ex_mem_reg_rd(forward_ex_mem_reg_rd),
    .ex_mem_reg_write(forward_ex_mem_reg_write),
    .mem_wb_reg_rd(forward_mem_wb_reg_rd),
    .mem_wb_reg_write(forward_mem_wb_reg_write),
    .alu_ex_mem(forward_alu_ex_mem),
    .alu_data_mem_wb(s_alu_data_mem_wb),

    // Saídas sinais de controle WB
    .mem_to_reg_out(s_mem_to_reg_ex_mem),
    .reg_write_out(s_reg_write_ex_mem),
    // Saídas sinais de controle MEM
    .mem_read_out(s_mem_read_ex_mem),
    .mem_write_out(s_mem_write_ex_mem),
    .beq_instruction_out(s_beq_instruction_ex_mem),
    // Sinal de controle para ID
    .rd_ex(s_rd_ex),
    // Saídas do banco de registradores EX/MEM
    .alu_result_out(alu_result_ex_mem),
    .mux2_result_out(mux2_result_ex_mem),
    .reg_rd_out(reg_rd_ex_mem),
    .flag_beq_out(flag_beq_ex_mem)
);

MEM MEM_stage(
    .clock(clock),
    .reset(reset),
    // Sinais de controle WB
    .mem_to_reg_in(s_mem_to_reg_ex_mem),
    .reg_write_in(s_reg_write_ex_mem),
    // Sinais de controle MEM
    .mem_read_in(s_mem_read_ex_mem),
    .mem_write_in(s_mem_write_ex_mem),
    .beq_instruction_in(s_beq_instruction_ex_mem),
    // Entrada de dados
    .alu_result_in(alu_result_ex_mem),
    .mux2_result_in(mux2_result_ex_mem),
    .flag_beq_in(flag_beq_ex_mem),
    // Enntrada do endereço do rd
    .reg_rd_in(reg_rd_ex_mem),

    // Saída dos sinais de controle WB
    .mem_to_reg_out(s_mem_to_reg_mem_wb),
    .reg_write_out(s_reg_write_mem_wb),
    // Saída do sinal pcSrc (instrução de branch)
    .pcSrc(s_pcSrc),
    // Saída de dados e rd[addr]
    .read_data_out(s_read_data_mem_wb),
    .alu_result_out(s_alu_result_mem_wb),
    .reg_rd_out(s_reg_rb_mem_wb),
    // Saída para forwading unit do estágio EX
    .ex_mem_reg_rd(forward_ex_mem_reg_rd),
    .ex_mem_reg_write(forward_ex_mem_reg_write),
    .alu_ex_mem(forward_alu_ex_mem)
);


WB WB_stage(
    .clock(clock),
    .reset(reset),
    // Sinais de controle WB
    .reg_write_in(s_reg_write_mem_wb),
    .mem_to_reg_in(s_mem_to_reg_mem_wb),
    // Entrada de dados
    .read_data_in(s_read_data_mem_wb),
    .alu_result_in(s_alu_result_mem_wb),
    .reg_rd_in(s_reg_rb_mem_wb),

    // Saida de dados
    .alu_data_mem_wb(s_alu_data_mem_wb),
    // Saida para forwarding unit do estagio EX
    .reg_rd_out(forward_mem_wb_reg_rd),
    .reg_write_out(forward_mem_wb_reg_write)
);

endmodule