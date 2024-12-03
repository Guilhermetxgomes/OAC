module register_file(
    input           clk,          // Sinal de clock
    input           habilita_escrita, // Habilitação de escrita
    input   [4:0]   endereco_fonte1,  // Endereço do registrador fonte 1
    input   [4:0]   endereco_fonte2,  // Endereço do registrador fonte 2
    input   [4:0]   endereco_destino, // Endereço do registrador de destino
    input   [31:0]  dado_escrita,    // Dados a serem escritos
    input           reset,           // Sinal de reset
    output  [31:0]  dado_fonte1,     // Dados do registrador fonte 1
    output  [31:0]  dado_fonte2      // Dados do registrador fonte 2
);

    wire [31:0] saidas [31:0]; // Fios conectando saídas de todos os registradores
    wire [31:0] habilitacao_escrita; // Fios para habilitação de escrita em cada registrador

    integer i;

    // Geração da lógica de habilitação de escrita
    assign habilitacao_escrita = (habilita_escrita) ? (1 << endereco_destino) : 32'b0;

    // Instanciação do registrador x0 (sempre zero)
    registrador x0 (
        .clk(clk),
        .habilita_escrita(1'b0),
        .dado_entrada(32'b0),
        .reset(reset),
        .dado_saida(saidas[0])
    );

    // Instanciação dos registradores x1 a x31
    genvar idx;
    generate
        for (idx = 1; idx < 32; idx = idx + 1) begin : registradores
            registrador registrador_instanciado (
                .clk(clk),
                .habilita_escrita(habilitacao_escrita[idx]),
                .dado_entrada(dado_escrita),
                .reset(reset),
                .dado_saida(saidas[idx])
            );
        end
    endgenerate

    assign saidas[32'd3] = 32'd1;
    assign saidas[32'd2] = 32'd5;
    // Leitura dos registradores fonte
    assign dado_fonte1 = saidas[endereco_fonte1];
    assign dado_fonte2 = saidas[endereco_fonte2];

endmodule
