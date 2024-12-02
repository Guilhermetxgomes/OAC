module decode_tb;

  // Declaração de sinais de entrada e saída
  reg clock;
  reg reset;
  reg write_enable;
  reg [31:0] instruction;
  reg [31:0] pc;
  reg [31:0] Din;
  reg [4:0] dest_ex_mem, dest_mem_wb, reg_destino_exe;

  wire pc_enable, if_id_enable;
  wire mem_to_reg_out, reg_write_out, mem_read_out;
  wire mem_write_out, beq_instruction_out, aluSrc_out;
  wire [1:0] aluOp_out;
  wire [4:0] rs1_out, rs2_out, rd_out;
  wire [31:0] imediato_out, pc_branch_value;
  wire mux_sel_IF;

  // Instancia o módulo `decode`
  decode uut (
    .clock(clock),
    .reset(reset),
    .write_enable(write_enable),
    .instruction(instruction),
    .pc(pc),
    .Din(Din),
    .dest_ex_mem(dest_ex_mem),
    .dest_mem_wb(dest_mem_wb),
    .reg_destino_exe(reg_destino_exe),
    .pc_enable(pc_enable),
    .if_id_enable(if_id_enable),
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
    .imediato_out(imediato_out),
    .pc_branch_value(pc_branch_value),
    .mux_sel_IF(mux_sel_IF)
  );

  // Geração de clock
  always #5 clock = ~clock;

  // Testa diferentes cenários
  initial begin
    // Inicialização
    $display("Iniciando Testbench...");
    clock = 0;
    reset = 1;
    write_enable = 0;
    instruction = 32'b0;
    pc = 32'h00000000;
    Din = 32'b0;
    dest_ex_mem = 5'b0;
    dest_mem_wb = 5'b0;
    reg_destino_exe = 5'b0;

    #10 reset = 0;

    // Teste 1: Instrução de tipo R (ex.: add x1, x2, x3)
    #10 instruction = {7'b0110011, 5'b00010, 5'b00011, 3'b000, 5'b00001, 7'b0000000};
    pc = 32'h00000010;

    #10;
    $display("Teste Tipo R:");
    $display("rs1_out: %d, rs2_out: %d, rd_out: %d, pc_branch_value: %h", rs1_out, rs2_out, rd_out, pc_branch_value);

    // Teste 2: Instrução de tipo SB (ex.: beq x1, x2, offset)
    #10 instruction = {7'b1100011, 5'b00001, 5'b00010, 3'b000, 5'b00000, 7'b0};
    pc = 32'h00000020;

    #10;
    $display("Teste Tipo SB:");
    $display("mux_sel_IF: %b, pc_branch_value: %h", mux_sel_IF, pc_branch_value);

    // Teste 3: Hazard de dados (dependência entre instruções)
    #10 dest_ex_mem = 5'b00001;
    instruction = {7'b0000011, 5'b00001, 5'b00000, 3'b000, 5'b00010, 7'b0000000}; // lw x2, 0(x1)

    #10;
    $display("Teste Hazard de Dados:");
    $display("stall_pipeline: %b, pc_enable: %b, if_id_enable: %b", uut.hazard_detection_unit.stall_pipeline, pc_enable, if_id_enable);

    // Finaliza o teste
    #20;
    $display("Finalizando Testbench...");
    $stop;
  end

endmodule
