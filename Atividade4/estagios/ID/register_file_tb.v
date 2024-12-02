`timescale 1ns / 1ps

module reg_file_tb;

    reg           clk;
    reg           habilita_escrita;
    reg  [4:0]    endereco_fonte1;
    reg  [4:0]    endereco_fonte2;
    reg  [4:0]    endereco_destino;
    reg  [31:0]   dado_escrita;
    reg           reset;
    wire [31:0]   dado_fonte1;
    wire [31:0]   dado_fonte2;

    // Instanciação do módulo reg_file
    register_file uut (
        .clk(clk),
        .habilita_escrita(habilita_escrita),
        .endereco_fonte1(endereco_fonte1),
        .endereco_fonte2(endereco_fonte2),
        .endereco_destino(endereco_destino),
        .dado_escrita(dado_escrita),
        .reset(reset),
        .dado_fonte1(dado_fonte1),
        .dado_fonte2(dado_fonte2)
    );

    // Geração do clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock de 10ns
    end

    // Testbench principal
    initial begin
        // Configuração do GTKWave
        $dumpfile("reg_file_tb.vcd");
        $dumpvars(0, reg_file_tb);

        // Monitoramento dos sinais
        $monitor($time, " Reset=%b, WE=%b, AddrD=%d, DataIn=%h, AddrF1=%d, DataOut1=%h, AddrF2=%d, DataOut2=%h",
                 reset, habilita_escrita, endereco_destino, dado_escrita, endereco_fonte1, dado_fonte1, endereco_fonte2, dado_fonte2);

        // Inicialização
        reset = 1;
        habilita_escrita = 0;
        endereco_fonte1 = 0;
        endereco_fonte2 = 0;
        endereco_destino = 0;
        dado_escrita = 0;

        // Resetar registradores
        #10 reset = 0;

        // Teste 1: Escrever no registrador x1
        #10;
        habilita_escrita = 1;
        endereco_destino = 5'd1; // x1
        dado_escrita = 32'hA5A5A5A5;
        #10;
        habilita_escrita = 0;

        // Teste 2: Ler do registrador x1
        #10;
        endereco_fonte1 = 5'd1; // x1

        // Teste 3: Escrever no registrador x2
        #10;
        habilita_escrita = 1;
        endereco_destino = 5'd2; // x2
        dado_escrita = 32'h5A5A5A5A;
        #10;
        habilita_escrita = 0;

        // Teste 4: Ler do registrador x2
        #10;
        endereco_fonte2 = 5'd2; // x2

        // Teste 5: Garantir que x0 sempre é zero
        #10;
        endereco_fonte1 = 5'd0; // x0

        // Finalizar a simulação
        #50;
        $finish;
    end

endmodule
