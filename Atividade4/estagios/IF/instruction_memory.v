module instruction_memory(
    input   [31:0]  addr,       // Endereço
    input   [31:0]  Din,        // Dados de entrada
    input           we,         // Habilitação de escrita
    input           re,         // Habilitação de leitura
    input           clk,        // Clock
    output  [31:0]  out         // Dados de saída
);

    parameter size = 256;          // Tamanho da memória
    integer i;                     // Iterador para inicialização

    reg [31:0] memory [0:size-1];  // Declaração da memória como array de 256 posições de 32 bits

    // Inicialização da memória
    initial begin
        for(i = 0; i < size; i = i + 1) begin
            memory[i] = 32'b0;
        end

        // Exemplo de instruções predefinidas na memória
        memory[0] = 32'b000000000011_00000_010_00001_0000011; // lw x1, 3(x0)
        memory[1] = 32'b000000000011_00000_010_00010_0000011; // lw x2, 3(x0)
        memory[2] = 32'b000000000111_00000_010_00011_0000011; // lw x3, 7(x0)
        memory[3] = 32'b000000000100_00000_010_00100_0000011; // lw x4, 4(x0)
        memory[4] = 32'b000000000011_00000_010_00101_0000011; // lw x5, 3(x0)
        memory[5] = 32'b0000000_00101_00001_000_01010_0110011; // add x10, x1, x5
        memory[6] = 32'b0_000000_00001_00001_000_1000_0_1100011; // beq x1, x1, imm=16
        memory[7] = 32'b0100000_00001_00010_000_00110_0110011; // sub x6, x2, x1
        memory[8] = 32'b0000000_00100_00011_010_00111_0100011; // sw x4, 7(x3)
        memory[22] = 32'b0000000_00010_00010_000_01011_0110011; // add x11, x2, x2
    end

    // Operação de escrita na borda positiva do clock
    always @(posedge clk) begin
        if (we) begin
            memory[addr[7:0]] <= Din;  // Escrita habilitada (somente nos 8 bits menos significativos do endereço)
        end
    end

    // Leitura da memória
    assign out = re ? memory[addr[7:0]] : 32'bz; // Leitura habilitada ou alta impedância

endmodule
