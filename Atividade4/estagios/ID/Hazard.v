module hazard_unit(
    input clk,
    input rst,
    input [6:0] inst_opcode,
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] dest_ex_mem,
    input [4:0] dest_mem_wb,
    input branch_ctrl_flag,
    input branch_taken_flag,
    output reg pc_enable,
    output reg if_id_enable,
    output reg stall_pipeline
);

localparam [6:0] TYPE_R = 7'b0110011,
                 TYPE_S = 7'b0100011,
                 TYPE_SB = 7'b1100011,
                 TYPE_I = 7'b0000011;

// Sinal para indicar dependências de dados
wire has_data_hazard;

assign has_data_hazard = (
    ((inst_opcode == TYPE_R) || (inst_opcode == TYPE_S) || (inst_opcode == TYPE_SB) || (inst_opcode == TYPE_I)) &&
    ((src1 != 0) && ((src1 == dest_ex_mem) || (src1 == dest_mem_wb)))
) || (
    ((inst_opcode == TYPE_R) || (inst_opcode == TYPE_S) || (inst_opcode == TYPE_SB)) &&
    ((src2 != 0) && ((src2 == dest_ex_mem) || (src2 == dest_mem_wb)))
);

// Controle do carregamento do PC
always @(*) begin
    if (rst) begin
        pc_enable = 0;
    end else begin
        pc_enable = ~has_data_hazard &&
                    ~((inst_opcode == TYPE_SB) && !branch_taken_flag);
    end
end

// Controle do carregamento do registrador IF/ID
always @(*) begin
    if (rst) begin
        if_id_enable = 0;
    end else begin
        if_id_enable = ~has_data_hazard;
    end
end

// Controle para inserir bolhas no pipeline
always @(*) begin
    if (rst) begin
        stall_pipeline = 0;
    end else begin
        stall_pipeline = has_data_hazard;
    end
end

endmodule
