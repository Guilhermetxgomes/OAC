module gerador_imediato (
    input [31:0] instruction,  // Instrução de entrada
    output [31:0] immediate    // Imediato gerado
);
    wire [6:0] opcode = instruction[6:0];  // Extrai o opcode da instrução
    wire [11:0] imm_i = instruction[31:20]; // Imediato do tipo I
    wire [11:0] imm_s = {instruction[31:25], instruction[11:7]}; // Imediato do tipo S
    wire [12:0] imm_b = {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // Imediato do tipo SB

    assign immediate =
        (opcode == 7'b0010011 || opcode == 7'b0000011) ? {{20{imm_i[11]}}, imm_i} : // Tipo I (addi, lw)
        (opcode == 7'b0100011)                  ? {{20{imm_s[11]}}, imm_s} :        // Tipo S (sw)
        (opcode == 7'b1100011)                  ? {{19{imm_b[12]}}, imm_b} :        // Tipo SB (beq, bne)
        32'b0; // Valor padrão caso o opcode não seja reconhecido
endmodule
