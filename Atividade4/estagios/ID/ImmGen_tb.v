module gerador_imediato_tb;

    // Entradas e saídas do módulo
    reg [31:0] instruction;  // Instrução de entrada
    wire [31:0] immediate;   // Imediato gerado

    // Instância do módulo a ser testado
    gerador_imediato uut (
        .instruction(instruction),
        .immediate(immediate)
    );

    // Inicialização e sequência de testes
    initial begin
        $dumpfile("gerador_imediato_tb.vcd");  // Arquivo de saída para o GTKWave
        $dumpvars(0, gerador_imediato_tb);     // Variáveis para rastreamento

        // Teste 1: Tipo I (addi, lw)
        instruction = 32'b000000000100_00001_010_00010_0000011; // lw x2, 4(x1)
        #10;
        $display("Teste 1 - Tipo I: Imediato esperado: 4 | Imediato gerado: %d", immediate);

        // Teste 2: Tipo S (sw)
        instruction = 32'b0000000_00010_00001_010_00100_0100011; // sw x2, 8(x1)
        #10;
        $display("Teste 2 - Tipo S: Imediato esperado: 4 | Imediato gerado: %d", immediate);

        // Teste 3: Tipo SB (beq)
        instruction = 32'b0000000_00011_00010_000_00010_1100011; // beq x3, x2, +4
        #10;
        $display("Teste 3 - Tipo SB: Imediato esperado: 2 | Imediato gerado: %d", immediate);

        // Teste 4: Valor padrão (opcode não reconhecido)
        instruction = 32'b0000000_00000_00000_000_00000_1111111; // Opcode inválido
        #10;
        $display("Teste 4 - Valor padrão: Imediato esperado: 0 | Imediato gerado: %d", immediate);

        // Finalizando o teste
        $finish;
    end

endmodule
