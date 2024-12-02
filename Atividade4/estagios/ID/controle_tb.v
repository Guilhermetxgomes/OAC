module controle_tb;

  // Entradas
  reg clock;
  reg reset;
  reg [6:0] opcode;

  // Saídas
  wire mem_to_reg_out;
  wire reg_write_out;
  wire mem_read_out;
  wire mem_write_out;
  wire beq_instruction_out;
  wire aluSrc_out;
  wire [1:0] aluOp_out;

  // Instância do módulo
  controle uut (
    .clock(clock),
    .reset(reset),
    .opcode(opcode),
    .mem_to_reg_out(mem_to_reg_out),
    .reg_write_out(reg_write_out),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .beq_instruction_out(beq_instruction_out),
    .aluSrc_out(aluSrc_out),
    .aluOp_out(aluOp_out)
  );

  // Geração de clock
  initial begin
    clock = 0;
    forever #5 clock = ~clock; // Clock com período de 10 unidades de tempo
  end

  // Estímulos de teste
  initial begin
    $dumpfile("controle_tb.vcd");
    $dumpvars(0, controle_tb);

    // Teste 1: Reset
    reset = 1;
    opcode = 7'b0000000; // Valor irrelevante durante o reset
    #10; // Aguarda um ciclo de clock
    reset = 0;

    // Teste 2: R-Type
    opcode = 7'b0110011; // Instruções R-Type
    #10;
    $display("R-Type: mem_to_reg=%b, reg_write=%b, mem_read=%b, mem_write=%b, beq_instruction=%b, aluSrc=%b, aluOp=%b",
             mem_to_reg_out, reg_write_out, mem_read_out, mem_write_out, beq_instruction_out, aluSrc_out, aluOp_out);

    // Teste 3: Load
    opcode = 7'b0000011; // Instruções Load
    #10;
    $display("Load: mem_to_reg=%b, reg_write=%b, mem_read=%b, mem_write=%b, beq_instruction=%b, aluSrc=%b, aluOp=%b",
             mem_to_reg_out, reg_write_out, mem_read_out, mem_write_out, beq_instruction_out, aluSrc_out, aluOp_out);

    // Teste 4: Store
    opcode = 7'b0100011; // Instruções Store
    #10;
    $display("Store: mem_to_reg=%b, reg_write=%b, mem_read=%b, mem_write=%b, beq_instruction=%b, aluSrc=%b, aluOp=%b",
             mem_to_reg_out, reg_write_out, mem_read_out, mem_write_out, beq_instruction_out, aluSrc_out, aluOp_out);

    // Teste 5: Branch
    opcode = 7'b1100011; // Instruções Branch
    #10;
    $display("Branch: mem_to_reg=%b, reg_write=%b, mem_read=%b, mem_write=%b, beq_instruction=%b, aluSrc=%b, aluOp=%b",
             mem_to_reg_out, reg_write_out, mem_read_out, mem_write_out, beq_instruction_out, aluSrc_out, aluOp_out);

    // Teste 6: Opcode desconhecido
    opcode = 7'b1111111; // Instrução inválida
    #10;
    $display("Desconhecido: mem_to_reg=%b, reg_write=%b, mem_read=%b, mem_write=%b, beq_instruction=%b, aluSrc=%b, aluOp=%b",
             mem_to_reg_out, reg_write_out, mem_read_out, mem_write_out, beq_instruction_out, aluSrc_out, aluOp_out);

    $finish; // Finaliza a simulação
  end
endmodule
