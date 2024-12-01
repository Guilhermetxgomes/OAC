module registrador(
    input           clk,          // Sinal de clock
    input           habilita_escrita, // Habilitação de escrita
    input   [31:0]  dado_entrada,     // Dado a ser armazenado no registrador
    input           reset,            // Sinal de reset
    output  reg [31:0] dado_saida     // Dado armazenado no registrador
);

    // Comportamento síncrono na borda negativa do clock
    always @(negedge clk) begin
        if (reset) begin
            dado_saida <= 32'b0; // Resetar registrador para 0
        end else if (habilita_escrita) begin
            dado_saida <= dado_entrada; // Atualizar valor do registrador
        end
    end

endmodule
