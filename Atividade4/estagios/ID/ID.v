module decode (
  input clock,
  input reset,
  input write_enable,
  input [31:0] instruction,
  input [31:0] pc,
  input [31:0] Din,
  input [4:0] dest_ex_mem,dest_mem_wb, reg_destino_exe,

  output pc_enable, if_id_enable,
  output mem_to_reg_out, reg_write_out, mem_read_out,
  output mem_write_out, beq_instruction_out, aluSrc_out,
  output [1:0] aluOp_out,
  output [4:0] rs1_out, rs2_out, rd_out,
  output [31:0] imediato_out, pc_branch_value,
  output mux_sel_IF,
  output IF_flush


);
  wire [31:0] imediato_interno;
  wire [4:0] ra_interno, rb_interno, rd_interno;
  wire [31:0] ra_saida_interno, rb_saida_interno;
  wire branch_taken_flag_interno, stall_pipeline_interno;
  wire mem_to_reg_interno,reg_write_interno,mem_read_interno, mem_write_interno, beq_instruction_interno, aluSrc_interno;
  wire [1:0] aluOp_interno;

  parameter [6:0] RTYPE = 7'b0110011,
                STYPE = 7'b0100011,
                SBTYPE = 7'b1100011,
                ITYPE =  7'b0000011;


  gerador_imediato imm_gen(
    .instruction(instruction),
    .immediate(imediato_interno)
  );

  register_file registradores(
    .clk(clock),
    .habilita_escrita(write_enable),
    .endereco_fonte1(ra_interno),
    .endereco_fonte2(rb_interno),
    .endereco_destino(reg_destino_exe),
    .dado_escrita(Din),
    .reset(reset),
    .dado_fonte1(ra_saida_interno),
    .dado_fonte2(rb_saida_interno)
  );

  hazard_unit hazard_detection_unit(
    .clk(clock),
    .rst(reset),
    .inst_opcode(instruction[6:0]),
    .src1(ra_interno),
    .src2(rb_interno),
    .dest_ex_mem(dest_ex_mem),
    .dest_mem_wb(dest_mem_wb),
    .branch_taken_flag(branch_taken_flag_interno),
    .pc_enable(pc_enable),
    .if_id_enable(if_id_enable),
    .stall_pipeline(stall_pipeline_interno)
  );

  controle control(
    .clock(clock),
    .reset(reset),
    .opcode(instruction[6:0]),
    .mem_to_reg_out(mem_to_reg_interno),
    .reg_write_out(reg_write_interno),
    .mem_read_out(mem_read_interno),
    .mem_write_out(mem_write_interno),
    .beq_instruction_out(beq_instruction_interno),
    .aluSrc_out(aluSrc_interno),
    .aluOp_out(aluOp_interno)
  );

  id_ex_register id_ex_register(
    .clk(clock),
    .reset(reset),
    .mem_to_reg_in(stall_pipeline_interno ? 1'b0 : mem_to_reg_interno),
    .reg_write_in(stall_pipeline_interno ? 1'b0 : reg_write_interno),
    .mem_read_in(stall_pipeline_interno ? 1'b0 : mem_read_interno),
    .mem_write_in(stall_pipeline_interno ? 1'b0 : mem_write_interno),
    .beq_instruction_in(stall_pipeline_interno ? 1'b0 : beq_instruction_interno),
    .aluSrc_in(stall_pipeline_interno ? 1'b0 : aluSrc_interno),
    .aluOp_in(stall_pipeline_interno ? 2'b0 : aluOp_interno),
    .rs1_in(ra_interno),
    .rs2_in(rb_interno),
    .rd_in(rd_interno),
    .imediato_in(imediato_interno),
    .mem_to_reg_out(mem_to_reg_out),
    .reg_write_out(reg_write_out),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .beq_instruction_out(beq_instruction_out),
    .aluSrc_out(aluSrc_out),
    .aluOp_out(aluOp_out),
    .rs1_out(rs1_out),
    .rs2_out(rs2_out),
    .rd_out(rd_out),
    .imediato_out(imediato_out)
  );



  assign ra_interno = instruction[19:15];
  assign rb_interno = instruction[24:20];
  assign rd_interno = instruction[11:7];
  assign pc_branch_value = pc + imediato_interno;
  assign branch_taken_flag_interno = (instruction[6:0] == SBTYPE) && (ra_saida_interno == rb_saida_interno);
  assign mux_sel_IF = branch_taken_flag_interno;
  assign IF_flush = branch_taken_flag_interno;



endmodule
