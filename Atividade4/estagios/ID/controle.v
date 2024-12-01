module controle (
  input clock,
  input reset,
  input [6:0] opcode,

  output reg mem_to_reg_out,
  output reg reg_write_out,
  output reg mem_read_out,
  output reg mem_write_out,
  output reg beq_instruction_out,
  output reg aluSrc_out,
  output reg [1:0] aluOp_out
);

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      // Reseta todos os sinais de controle
      mem_to_reg_out        <= 1'b0;
      reg_write_out         <= 1'b0;
      mem_read_out          <= 1'b0;
      mem_write_out         <= 1'b0;
      beq_instruction_out   <= 1'b0;
      aluSrc_out            <= 1'b0;
      aluOp_out             <= 2'b00;
    end else begin
      // Decodificação do opcode
      case (opcode)
        7'b0110011: begin // R-Type (e.g., ADD, SUB)
          mem_to_reg_out        <= 1'b0;
          reg_write_out         <= 1'b1;
          mem_read_out          <= 1'b0;
          mem_write_out         <= 1'b0;
          beq_instruction_out   <= 1'b0;
          aluSrc_out            <= 1'b0;
          aluOp_out             <= 2'b10; // Código para operações R-Type
        end
        7'b0000011: begin // Load (e.g., LW)
          mem_to_reg_out        <= 1'b1;
          reg_write_out         <= 1'b1;
          mem_read_out          <= 1'b1;
          mem_write_out         <= 1'b0;
          beq_instruction_out   <= 1'b0;
          aluSrc_out            <= 1'b1; // Usar imediato
          aluOp_out             <= 2'b00; // Código para LOAD
        end
        7'b0100011: begin // Store (e.g., SW)
          mem_to_reg_out        <= 1'b0; // Não escreve no registrador
          reg_write_out         <= 1'b0;
          mem_read_out          <= 1'b0;
          mem_write_out         <= 1'b1;
          beq_instruction_out   <= 1'b0;
          aluSrc_out            <= 1'b1; // Usar imediato
          aluOp_out             <= 2'b00; // Código para STORE
        end
        7'b1100011: begin // Branch (e.g., BEQ)
          mem_to_reg_out        <= 1'b0;
          reg_write_out         <= 1'b0;
          mem_read_out          <= 1'b0;
          mem_write_out         <= 1'b0;
          beq_instruction_out   <= 1'b1;
          aluSrc_out            <= 1'b0; // Usar valores do registrador
          aluOp_out             <= 2'b01; // Código para BEQ
        end
        default: begin // Caso padrão (instrução não reconhecida)
          mem_to_reg_out        <= 1'b0;
          reg_write_out         <= 1'b0;
          mem_read_out          <= 1'b0;
          mem_write_out         <= 1'b0;
          beq_instruction_out   <= 1'b0;
          aluSrc_out            <= 1'b0;
          aluOp_out             <= 2'b00; // Nenhuma operação
        end
      endcase
    end
  end

endmodule
