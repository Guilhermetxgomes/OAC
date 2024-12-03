`timescale 1ns / 1ps

module riscv_pipeline_tb;

    // Entradas do DUT (Device Under Test)
    reg clock;
    reg reset;
    reg ligar;

    // Instância do módulo riscv_pipeline
    riscv_pipeline DUT (
        .clock(clock),
        .reset(reset)
    );

    // Geração do clock (50 MHz => período de 20 ns)
    always begin
        #10 clock = ~clock; // Inverte o clock a cada 10 ns
    end

    // Procedimento inicial
    initial begin
        $dumpfile("riscv.vcd");  // Nome do arquivo de saída
        $dumpvars(0, riscv_pipeline_tb);     // Dump de todas as variáveis no escopo

        // Inicialização
        clock = 0;
        reset = 1;

        // Reset do sistema
        #25;
        reset = 0;

        // Teste 1: Pipeline desligado
        #50; // Aguarda 50 ns para verificar o comportamento com o pipeline desligado

        // Teste 2: Pipeline ligado
        #500;

        // // Teste 3: Pipeline ligado após reset
        // reset = 1;
        // #25;
        // reset = 0;
        // ligar = 1;
        // #100; // Aguarda 100 ns para observar o comportamento normal do pipeline

        // Finalizar a simulação
        $finish;
    end

    // Monitoramento dos sinais principais para depuração
    initial begin
        $monitor("Time=%0dns | reset=%b | clock=%b",
                 $time, reset, clock);
    end

endmodule
