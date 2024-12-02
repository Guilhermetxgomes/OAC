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
    input       [31:0]  imediato_in,            // Imediato

    output              mem_to_reg_out,
    output              reg_write_out,
    output              mem_read_out,
    output              mem_write_out,
    output              beq_instruction_out,
    output              aluSrc_out,
    output      [1:0]   aluOp_out,
    output      [4:0]   rs1_out, rs2_out, rd_out,
    output      [31:0]  imediato_out
);

    // Registradores internos para os sinais
    reg mem_to_reg_out_interno;
    reg reg_write_out_interno;
    reg mem_read_out_interno;
    reg mem_write_out_interno;
    reg beq_instruction_out_interno;
    reg aluSrc_out_interno;
    reg [1:0] aluOp_out_interno;
    reg [4:0] rs1_out_interno, rs2_out_interno, rd_out_interno;
    reg [31:0] imediato_out_interno;

    // Bloco síncrono
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_to_reg_out_interno      <= 1'b0;
            reg_write_out_interno       <= 1'b0;
            mem_read_out_interno        <= 1'b0;
            mem_write_out_interno       <= 1'b0;
            beq_instruction_out_interno <= 1'b0;
            aluSrc_out_interno          <= 1'b0;
            aluOp_out_interno           <= 2'b0;

            rs1_out_interno             <= 5'b0;
            rs2_out_interno             <= 5'b0;
            rd_out_interno              <= 5'b0;
            imediato_out_interno        <= 32'b0;
        end else begin
            mem_to_reg_out_interno      <= mem_to_reg_in;
            reg_write_out_interno       <= reg_write_in;
            mem_read_out_interno        <= mem_read_in;
            mem_write_out_interno       <= mem_write_in;
            beq_instruction_out_interno <= beq_instruction_in;
            aluSrc_out_interno          <= aluSrc_in;
            aluOp_out_interno           <= aluOp_in;
            rs1_out_interno             <= rs1_in;
            rs2_out_interno             <= rs2_in;
            rd_out_interno              <= rd_in;
            imediato_out_interno        <= imediato_in;
        end
    end

    // Atribuições para os sinais de saída
    assign mem_to_reg_out      = mem_to_reg_out_interno;
    assign reg_write_out       = reg_write_out_interno;
    assign mem_read_out        = mem_read_out_interno;
    assign mem_write_out       = mem_write_out_interno;
    assign beq_instruction_out = beq_instruction_out_interno;
    assign aluSrc_out          = aluSrc_out_interno;
    assign aluOp_out           = aluOp_out_interno;
    assign rs1_out             = rs1_out_interno;
    assign rs2_out             = rs2_out_interno;
    assign rd_out              = rd_out_interno;
    assign imediato_out         = imediato_out_interno;

endmodule
