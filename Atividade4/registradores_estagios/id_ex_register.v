module id_ex_register (
    input               clk,
    input               reset,
    input               mem_to_reg_in,
    input               reg_write_in,
    input               mem_read_in,
    input               mem_write_in,
    input               beq_instruction_in,
    input               aluSrc_in,
    input       [1:0]   aluOp_in,
    input       [4:0]   rs1_in, rs2_in, rd_in,  // Registradores
    input       [31:0]  imediato_in,// Imediato

    output reg          mem_to_reg_out,
    output reg          reg_write_out,
    output reg          mem_read_out,
    output reg          mem_write_out,
    output reg          beq_instruction_out,
    output reg          aluSrc_out,
    output reg  [1:0]   aluOp_out,
    output reg  [4:0]   rs1_out, rs2_out, rd_out,
    output reg  [31:0]  imediato_out
);

    // Bloco síncrono
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_to_reg_out      <= 1'b0;
            reg_write_out       <= 1'b0;
            mem_read_out        <= 1'b0;
            mem_write_out       <= 1'b0;
            beq_instruction_out <= 1'b0;
            aluSrc_out          <= 1'b0;
            aluOp_out           <= 2'b0;

            rs1_out             <= 5'b0;
            rs2_out             <= 5'b0;
            rd_out              <= 5'b0;
            imediato_out        <= 32'b0;
        end else begin
            mem_to_reg_out      <= mem_to_reg_in;
            reg_write_out       <= reg_write_in;
            mem_read_out        <= mem_read_in;
            mem_write_out       <= mem_write_in;
            beq_instruction_out <= beq_instruction_in;
            aluSrc_out          <= aluSrc_in;
            aluOp_out           <= aluOp_in;
            rs1_out             <= rs1_in;
            rs2_out             <= rs2_in;
            rd_out              <= rd_in;
            imediato_out        <= imediato_in;
        end
    end

endmodule
