`timescale 1ns/1ps

module WB_tb;

    // Entradas
    reg clock;
    reg reset;
    reg reg_write_in;
    reg mem_to_reg_in;
    reg [31:0] read_data_in;
    reg [31:0] alu_result_in;
    reg [4:0] reg_rd_in;

    // Saídas
    wire [31:0] alu_data_mem_wb;
    wire [4:0] reg_rd_out;
    wire reg_write_out;

    // Instância do módulo WB
    WB dut (
        .clock(clock),
        .reset(reset),
        .reg_write_in(reg_write_in),
        .mem_to_reg_in(mem_to_reg_in),
        .read_data_in(read_data_in),
        .alu_result_in(alu_result_in),
        .reg_rd_in(reg_rd_in),
        .alu_data_mem_wb(alu_data_mem_wb),
        .reg_rd_out(reg_rd_out),
        .reg_write_out(reg_write_out)
    );

    // Clock de 10ns
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // Testbench
    initial begin
        // Inicializações
        reset = 1;
        reg_write_in = 0;
        mem_to_reg_in = 0;
        read_data_in = 0;
        alu_result_in = 0;
        reg_rd_in = 0;

        // Espera pelo reset
        #10;
        reset = 0;

        // Teste 1: Escrever o resultado da ALU no banco de registradores
        reg_write_in = 1;
        mem_to_reg_in = 0;  // Seleciona alu_result_in
        alu_result_in = 32'hA5A5A5A5;
        reg_rd_in = 5'b01010; // Registrador destino

        #10;
        $display("Test 1: alu_data_mem_wb = %h, reg_rd_out = %b, reg_write_out = %b", 
                  alu_data_mem_wb, reg_rd_out, reg_write_out);

        // Teste 2: Escrever o dado da memória no banco de registradores
        mem_to_reg_in = 1;  // Seleciona read_data_in
        read_data_in = 32'h5A5A5A5A;

        #10;
        $display("Test 2: alu_data_mem_wb = %h, reg_rd_out = %b, reg_write_out = %b", 
                  alu_data_mem_wb, reg_rd_out, reg_write_out);

        // Teste 3: Desabilitar escrita no banco de registradores
        reg_write_in = 0;

        #10;
        $display("Test 3: alu_data_mem_wb = %h, reg_rd_out = %b, reg_write_out = %b", 
                  alu_data_mem_wb, reg_rd_out, reg_write_out);

        // Finaliza a simulação
        #10;
        $finish;
    end

endmodule
