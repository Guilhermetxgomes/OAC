module instruction_memory (
    input [31:0] addr,        // Endereço de entrada (PC)
    output reg [31:0] instr   // Instrução correspondente ao endereço
);

    // ROM com algumas instruções em formato binário
    always @(*) begin
        case (addr[9:2]) // Usamos 8 bits de endereçamento para 256 instruções
            // Carrega o valor de uma posição de memória no registrador
            8'h00: instr = 32'b000000000001_00001_010_00010_0000011; // lw x2, 1(x1)

            // Armazena o valor de um registrador em uma posição de memória
            8'h01: instr = 32'b000000000010_00010_010_00001_0100011; // sw x2, 2(x1)

            // Soma dois registradores
            8'h02: instr = 32'b0000000_00010_00011_000_00100_0110011; // add x4, x3, x2

            // Subtrai dois registradores
            8'h03: instr = 32'b0100000_00010_00011_000_00101_0110011; // sub x5, x3, x2

            // AND lógico entre dois registradores
            8'h04: instr = 32'b0000000_00010_00011_111_00110_0110011; // and x6, x3, x2

            // OR lógico entre dois registradores
            8'h05: instr = 32'b0000000_00010_00011_110_00111_0110011; // or x7, x3, x2

            // Salta se os valores de dois registradores forem iguais
            8'h06: instr = 32'b0000000_00101_00100_000_00001_1100011; // beq x5, x4, +1

            // Finaliza com uma instrução NOP (No Operation)
            8'h07: instr = 32'b0000000_00000_00000_000_00000_0010011; // nop

            default: instr = 32'b0; // Instrução padrão (NOP)
        endcase
    end

endmodule
