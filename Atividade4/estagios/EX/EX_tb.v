`timescale 1ns/1ps

module EX_tb;

    // Entradas
    reg clock, reset;
    reg [31:0] reg_a_in, reg_b_in, immediate_in;
    reg mem_to_reg_in, reg_write_in, mem_read_in, mem_write_in, beq_instruction_in;
    reg aluSrc_in;
    reg [1:0] aluOp_in;
    reg [6:0] funct7_in;
    reg [2:0] funct3_in;
    reg [4:0] reg_rs1_in, reg_rs2_in, reg_rd_in, ex_mem_reg_rd, mem_wb_reg_rd;
    reg ex_mem_reg_write, mem_wb_reg_write;
    reg [31:0] alu_ex_mem, alu_data_mem_wb;

    // Saídas
    wire mem_to_reg_out, reg_write_out, mem_read_out, mem_write_out, beq_instruction_out;
    wire [31:0] alu_result_out, mux2_result_out;
    wire [4:0] reg_rd_out;
    wire flag_beq_out;

    // Instância do módulo EX
    EX uut (
        .clock(clock),
        .reset(reset),
        .reg_a_in(reg_a_in),
        .reg_b_in(reg_b_in),
        .immediate_in(immediate_in),
        .mem_to_reg_in(mem_to_reg_in),
        .reg_write_in(reg_write_in),
        .mem_read_in(mem_read_in),
        .mem_write_in(mem_write_in),
        .beq_instruction_in(beq_instruction_in),
        .aluSrc_in(aluSrc_in),
        .aluOp_in(aluOp_in),
        .funct7_in(funct7_in),
        .funct3_in(funct3_in),
        .reg_rs1_in(reg_rs1_in),
        .reg_rs2_in(reg_rs2_in),
        .reg_rd_in(reg_rd_in),
        .ex_mem_reg_rd(ex_mem_reg_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_reg_rd(mem_wb_reg_rd),
        .mem_wb_reg_write(mem_wb_reg_write),
        .alu_ex_mem(alu_ex_mem),
        .alu_data_mem_wb(alu_data_mem_wb),
        .mem_to_reg_out(mem_to_reg_out),
        .reg_write_out(reg_write_out),
        .mem_read_out(mem_read_out),
        .mem_write_out(mem_write_out),
        .beq_instruction_out(beq_instruction_out),
        .alu_result_out(alu_result_out),
        .mux2_result_out(mux2_result_out),
        .reg_rd_out(reg_rd_out),
        .flag_beq_out(flag_beq_out)
    );

    // Clock de 10ns
    always #5 clock = ~clock;

    initial begin
        $dumpfile("a.vcd");
        $dumpvars(0, EX_tb);
        // Inicialização
        clock = 0;
        reset = 1;
        reg_a_in = 0; reg_b_in = 0; immediate_in = 0;
        mem_to_reg_in = 0; reg_write_in = 0; mem_read_in = 0; mem_write_in = 0; beq_instruction_in = 0;
        aluSrc_in = 0; aluOp_in = 0;
        funct7_in = 0; funct3_in = 0;
        reg_rs1_in = 0; reg_rs2_in = 0; reg_rd_in = 0;
        ex_mem_reg_rd = 0; ex_mem_reg_write = 0;
        mem_wb_reg_rd = 0; mem_wb_reg_write = 0;
        alu_ex_mem = 0; alu_data_mem_wb = 0;

        // Aguardar alguns ciclos para reset
        #10 reset = 0;

        // Teste 1: Operação ADD (sem imediato, sem forwarding)
        aluOp_in = 2'b10;         // Código de operação para ALU
        funct7_in = 7'b0000000;   // Função para ADD
        funct3_in = 3'b000;
        reg_a_in = 32'h00000005;  // Operando A
        reg_b_in = 32'h00000003;  // Operando B
        aluSrc_in = 0;            // Selecionar registrador como fonte

        #10;
        // Verificar resultado
        if (uut.alu_result != 32'h00000008)
            $display("Erro no Teste 1: alu_result = %h, esperado = 8", uut.alu_result);
        else
            $display("Teste 1: PASSOU - alu_result = %h", uut.alu_result);


        #10
        // Teste 2: Operação SUB
        aluOp_in = 2'b10;
        funct7_in = 7'b0100000;
        funct3_in = 3'b000; 

        #10;
        // Verificar resultado
        if (uut.alu_result != 32'h00000002)
            $display("Erro no Teste 2: alu_result = %h, esperado = 2", uut.alu_result);
        else
            $display("Teste 2: PASSOU - alu_result = %h", uut.alu_result);

        #10
        // Teste 3: Operação OR
        aluOp_in = 2'b10;
        funct7_in = 7'b0000000;
        funct3_in = 3'b110;
        reg_a_in = 32'b10000001000000000000000010000001;  // Operando A
        reg_b_in = 32'b00000000100000011000000100000000;  // Operando B 

        #10;
        // Verificar resultado
        if (uut.alu_result != 32'b10000001100000011000000110000001)
            $display("Erro no Teste 3: alu_result = %b", uut.alu_result);
        else
            $display("Teste 3: PASSOU - alu_result = %b", uut.alu_result);

         #10
        // Teste 4: Operação AND
        aluOp_in = 2'b10;
        funct7_in = 7'b0000000;
        funct3_in = 3'b111;
        reg_a_in = 32'b10000001000000000000000010000001;  // Operando A
        reg_b_in = 32'b10000001100000011000000100000001;  // Operando B 

        #10;
        // Verificar resultado
        if (uut.alu_result != 32'b10000001000000000000000000000001)
            $display("Erro no Teste 4: alu_result = %b", uut.alu_result);
        else
            $display("Teste 4: PASSOU - alu_result = %b", uut.alu_result);

         #10
        // Teste 5: Operação ADD (ld ou sd)
        aluOp_in = 2'b00;
        reg_a_in = 32'h00000008;  // Operando A
        reg_b_in = 32'h00000001;  // Operando B 

        #10;
        // Verificar resultado
        if (uut.alu_result != 32'h00000009)
            $display("Erro no Teste 5: alu_result = %h", uut.alu_result);
        else
            $display("Teste 5: PASSOU - alu_result = %h", uut.alu_result);

        #10
        // Teste 6: Operação SUB (beq)
        aluOp_in = 2'b01;
        reg_a_in = 32'h10000005;  // Operando A
        reg_b_in = 32'h10000005;  // Operando B 

        #10;
        // Verificar resultado
        if (uut.flag_beq != 1'b1)
            $display("Erro no Teste 6: flag_beq = %b", uut.flag_beq);
        else
            $display("Teste 6: PASSOU - flag_beq = %b - alu_result = %h", uut.flag_beq, uut.alu_result);
        
        #10
        // Teste 7: Operação ADD com imediato
        aluOp_in = 2'b10;         // Código de operação para ALU
        funct7_in = 7'b0000000;   // Função para ADD
        funct3_in = 3'b000;
        reg_a_in = 32'h00000005;  // Operando A
        reg_b_in = 32'h00000003;  // Operando B
        immediate_in = 32'h00000002; // Valor imediato
        aluSrc_in = 1;               // Selecionar imediato como fonte
        #10;

        // Verificar resultado
        if (uut.alu_result != 32'h00000007)
            $display("Erro no Teste 7: alu_result = %h, esperado = 7", uut.alu_result);
        else
            $display("Teste 7: PASSOU - alu_result = %h", uut.alu_result);

        // Teste 8: Forwarding (registradores diferentes)
        ex_mem_reg_rd = 5'b00001;   // Registrador de destino no estágio EX/MEM
        ex_mem_reg_write = 1;      // Habilitar escrita
        mem_wb_reg_rd = 5'b00010;  // Registrador de destino no estágio MEM/WB
        mem_wb_reg_write = 1;      // Habilitar escrita
        alu_ex_mem = 32'h00000009; // Valor calculado no estágio EX/MEM
        alu_data_mem_wb = 32'h00000001; // Valor calculado no estágio MEM/WB
        reg_rs1_in = 5'b00001;     // Registrador fonte 1 depende do estágio EX/MEM
        reg_rs2_in = 5'b00010;     // Registrador fonte 2 depende do estágio MEM/WB
        aluSrc_in = 0;
        #10;

        $display("Teste 8");
        $display("Forwarding - ForwardA = %b, ForwardB = %b", uut.forwardA, uut.forwardB);
        $display("ULA: a = %h - b = %h, - alu_result = %h", uut.alu_ex.b, uut.alu_ex.a, uut.alu_result);
        $display("REG_A = %h -- REG_B = %h", uut.reg_a_in, uut.reg_b_in);

        // Finalizar simulação
        #10 $finish;
    end

endmodule