`timescale 1ns / 1ps

module hazard_unit_tb;

    reg clk;
    reg rst;
    reg [6:0] inst_opcode;
    reg [4:0] src1;
    reg [4:0] src2;
    reg [4:0] dest_ex_mem;
    reg [4:0] dest_mem_wb;
    reg branch_ctrl_flag;
    reg branch_taken_flag;
    wire pc_enable;
    wire if_id_enable;
    wire stall_pipeline;

    // Instanciação do módulo sob teste
    hazard_unit uut (
        .clk(clk),
        .rst(rst),
        .inst_opcode(inst_opcode),
        .src1(src1),
        .src2(src2),
        .dest_ex_mem(dest_ex_mem),
        .dest_mem_wb(dest_mem_wb),
        .branch_ctrl_flag(branch_ctrl_flag),
        .branch_taken_flag(branch_taken_flag),
        .pc_enable(pc_enable),
        .if_id_enable(if_id_enable),
        .stall_pipeline(stall_pipeline)
    );

    // Geração do clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock com período de 10ns
    end

    // Testbench principal
    initial begin
        // Configuração para visualização
        $dumpfile("hazard_unit_tb.vcd");
        $dumpvars(0, hazard_unit_tb);

        // Inicialização
        rst = 1;
        inst_opcode = 7'b0;
        src1 = 5'b0;
        src2 = 5'b0;
        dest_ex_mem = 5'b0;
        dest_mem_wb = 5'b0;
        branch_ctrl_flag = 0;
        branch_taken_flag = 0;

        #10 rst = 0;

        // Teste 1: Sem hazard, PC e IF/ID habilitados
        #10;
        inst_opcode = 7'b0110011; // R-TYPE
        src1 = 5'd1;
        src2 = 5'd2;
        dest_ex_mem = 5'd3;
        dest_mem_wb = 5'd4;

        // Teste 2: Hazard de dados no src1
        #10;
        dest_ex_mem = 5'd1;

        // Teste 3: Hazard de dados no src2
        #10;
        dest_ex_mem = 5'd0;
        dest_mem_wb = 5'd2;

        // Teste 4: Hazard de controle (branch)
        #10;
        inst_opcode = 7'b1100011; // SB-TYPE
        branch_ctrl_flag = 1;
        branch_taken_flag = 0;

        // Teste 5: Hazard de controle resolvido
        #10;
        branch_taken_flag = 1;

        // Teste 6: Reset
        #10;
        rst = 1;

        // Finalização
        #10;
        $finish;
    end

endmodule
