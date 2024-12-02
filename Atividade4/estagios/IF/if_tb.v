module fetch_tb;

  // Definindo os sinais
  reg clock;
  reg reset;
  reg [31:0] pc_branch_value;
  reg mux_sel;
  reg load_pc;
  reg load_if_id_register;
  reg if_flush;  // Nova entrada para flush
  wire [31:0] pc_out;
  wire [31:0] instrucao;

  // Instanciando o módulo 'fetch'
  fetch uut (
    .clock(clock),
    .reset(reset),
    .pc_branch_value(pc_branch_value),
    .mux_sel(mux_sel),
    .load_pc(load_pc),
    .load_if_id_register(load_if_id_register),
    .if_flush(if_flush),  // Conexão do novo sinal
    .pc_out(pc_out),
    .instrucao(instrucao)
  );

  // Gerador de clock
  always begin
    #5 clock = ~clock;  // Clock com período de 10 unidades de tempo
  end

  // Inicialização dos sinais e sequência de testes
  initial begin
    // Configuração do dump para o GTKWave
    $dumpfile("fetch_tb.vcd");  // Nome do arquivo de saída
    $dumpvars(0, fetch_tb);     // Dump de todas as variáveis no escopo

    // Inicializando os sinais
    clock = 0;
    reset = 0;
    pc_branch_value = 32'h00000000;  // Valor fictício para PC de branch
    mux_sel = 0;  // Seleciona o incremento de PC normal
    load_pc = 0;
    load_if_id_register = 0;
    if_flush = 0;  // Inicializa sem flush

    // Teste 1: Reset do sistema
    $display("Test 1: Reset");
    reset = 1;  // Ativa o reset
    #10;
    reset = 0;  // Desativa o reset

    // Teste 2: Testando o incremento de PC normal
    $display("Test 2: Incremento de PC");
    load_pc = 1;  // Ativa o carregamento do PC
    load_if_id_register = 1;  // Ativa o carregamento do IF/ID
    #10;

    // Teste 3: Testando o desvio de PC (branch)
    $display("Test 3: Branch no PC");
    mux_sel = 1;  // Seleciona o valor de branch
    pc_branch_value = 32'h00000010;  // Novo valor para o PC (exemplo de branch)
    #10;

    // Teste 4: Ativando o flush
    $display("Test 4: Flush ativado");
    if_flush = 1;  // Ativa o flush
    #10;
    if_flush = 0;  // Desativa o flush

    // Teste 5: Testando novamente sem desvio de PC
    $display("Test 5: Sem Branch");
    mux_sel = 0;  // Seleciona o incremento normal de PC
    #10;

    // Teste 6: Teste com novo carregamento de instrução
    $display("Test 6: Novo Carregamento de Instrução");
    load_pc = 1;  // Carregar o PC
    load_if_id_register = 1;  // Carregar o registro IF/ID
    #10;

    // Finalizando o teste
    $finish;
  end

  // Monitorando as saídas
  initial begin
    $monitor("Time: %0d | PC: %h | Instrução: %h | Flush: %b", $time, pc_out, instrucao, if_flush);
  end

endmodule
