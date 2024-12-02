module ex_mem_register (
    input clock,
    input reset,
    // Sinais de controle WB
    input       mem_to_reg_in,
    input       reg_write_in,
    // Sinais de controle MEM
    input       mem_read_in,
    input       mem_write_in,
    input       beq_instruction_in,
    // Sinais de dados
    input [31:0] alu_result_in,
    input [31:0] mux2_result_in,
    input [4:0] reg_rd_in,
    input       flag_beq_in,
    // Saídas sinais de controle WB
    output      mem_to_reg_out,
    output      reg_write_out,
    // Saídas sinais de controle MEM
    output      mem_read_out,
    output      mem_write_out,
    output      beq_instruction_out,
    // Saídas do banco de registradores EX/MEM
    output [31:0] alu_result_out,
    output [31:0] mux2_result_out,
    output [4:0] reg_rd_out,
    output       flag_beq_out
);

reg      mem_to_reg_value;
reg      reg_write_value;
reg      mem_read_value;
reg      beq_instruction_value;
reg [31:0] alu_result_value;
reg [31:0] mux2_result_value;
reg [4:0] reg_rd_value;
reg      flag_beq_value;

    always @(posedge clock) begin
        if(reset) begin
            mem_to_reg_value <= 1'b0;
            reg_write_value <= 1'b0;
            mem_read_value <= 1'b0;
            beq_instruction_value <= 1'b0;
            alu_result_value <= 32'd0;
            mux2_result_value <= 32'd0;
            reg_rd_value <= 5'd0;
            flag_beq_value <= 1'b0;
        end else begin
            mem_to_reg_value <= mem_to_reg_in;
            reg_write_value <= reg_write_in;
            mem_read_value <= mem_read_in;
            beq_instruction_value <= beq_instruction_in;
            alu_result_value <= alu_result_in;
            mux2_result_value <= mux2_result_in;
            reg_rd_value <= reg_rd_in;
            flag_beq_value <= flag_beq_in;
        end
    end

assign mem_to_reg_out = mem_to_reg_value;
assign reg_write_out = reg_write_value;
assign mem_read_out = mem_read_value;
assign beq_instruction_out = beq_instruction_value;
assign alu_result_out = alu_result_value;
assign mux2_result_out = mux2_result_value;
assign reg_rd_out = reg_rd_value;
assign flag_beq_out = flag_beq_value;


endmodule
