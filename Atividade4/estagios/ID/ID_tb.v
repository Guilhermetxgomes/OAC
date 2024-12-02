module decode_tb;

  // Declaração de sinais de entrada
  reg clock;
  reg reset;
  reg write_enable;
  reg [31:0] instruction;
  reg [31:0] pc;
  reg [31:0] Din;
  reg [4:0] dest_ex_mem, dest_mem_wb, reg_destino_exe;

  // Declaração de sinais de saída
  wire pc_enable, if_id_enable;
  wire mem_to_reg_out, reg_write_out, mem_read_out;
  wire mem_write_out, beq_instruction_out, aluSrc_out;
  wire [1:0] aluOp_out;
  wire [4:0] rs1_out, rs2_out, rd_out;
  wire [31:0] imediato_out, pc_branch_value;

  // Instância do módulo decode
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
    .pc_branch_value(pc_branch_value)
  );

  // Clock generation
  always begin
    #5 clock = ~clock;  // Clock com período de 10 unidades de tempo
  end

  // Estímulos do testbench
  initial begin
    // Inicialização dos sinais
    clock = 0;
    reset = 1;
    write_enable = 1;
    instruction = 32'b0;
    pc = 32'h00000000;
    Din = 32'h00000000;
    dest_ex_mem = 5'b00000;
    dest_mem_wb = 5'b00000;
    reg_destino_exe = 5'b00000;

    // Inicializar o arquivo VCD
    $dumpfile("decode_tb.vcd"); // Nome do arquivo VCD
    $dumpvars(0, decode_tb); // Gera a forma de onda para todo o testbench

    // Teste 1: Reset do sistema
    #10 reset = 0;  // Reset desativado
    instruction = 32'b00000000000000000000000000000000; // NOP ou instrução vazia
    #10 instruction = 32'b00000000000000000000000010010011; // Instrução tipo R, ADDI

    // Teste 2: Instrução tipo R (ADD)
    #10 instruction = 32'b00000000000100000000000100010011; // ADD tipo R
    #10 reset = 1;

    // Teste 3: Instrução de branch (BEQ)
    #10 instruction = 32'b11000000000100000000000000010011; // BEQ tipo SB
    #10 reset = 0;

    // Teste 4: Instrução de carga (LW)
    #10 instruction = 32'b00000000000000000000000000000111; // LW tipo I
    #10 reset = 1;

    // Teste 5: Finalizando a simulação
    #10 $finish;
  end

  // Monitoramento dos sinais
  initial begin
    $monitor("Time: %0t | instruction: %b | pc: %h | pc_enable: %b | mem_to_reg_out: %b | reg_write_out: %b | reg_destino_exe: %b | immediate_out: %h | branch_address: %h",
             $time, instruction, pc, pc_enable, mem_to_reg_out, reg_write_out, reg_destino_exe, imediato_out, pc_branch_value);
  end

endmodule
