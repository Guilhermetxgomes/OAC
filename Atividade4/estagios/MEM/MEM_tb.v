`timescale 1ns/1ps

module tb_MEM;

    // Entradas
    reg clock;
    reg reset;
    reg mem_to_reg_in;
    reg reg_write_in;
    reg mem_read_in;
    reg mem_write_in;
    reg beq_instruction_in;
    reg [31:0] alu_result_in;
    reg [31:0] mux2_result_in;
    reg flag_beq_in;
    reg [4:0] reg_rd_in;

    // Saídas
    wire mem_to_reg_out;
    wire reg_write_out;
    wire pcSrc;
    wire [31:0] read_data_out;
    wire [31:0] alu_result_out;
    wire [4:0] reg_rd_out;
    wire [4:0] ex_mem_reg_rd;
    wire ex_mem_reg_write;
    wire [31:0] alu_ex_mem;

    // Instância do módulo MEM
    MEM uut (
        .clock(clock),
        .reset(reset),
        .mem_to_reg_in(mem_to_reg_in),
        .reg_write_in(reg_write_in),
        .mem_read_in(mem_read_in),
        .mem_write_in(mem_write_in),
        .beq_instruction_in(beq_instruction_in),
        .alu_result_in(alu_result_in),
        .mux2_result_in(mux2_result_in),
        .flag_beq_in(flag_beq_in),
        .reg_rd_in(reg_rd_in),
        .mem_to_reg_out(mem_to_reg_out),
        .reg_write_out(reg_write_out),
        .pcSrc(pcSrc),
        .read_data_out(read_data_out),
        .alu_result_out(alu_result_out),
        .reg_rd_out(reg_rd_out),
        .ex_mem_reg_rd(ex_mem_reg_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .alu_ex_mem(alu_ex_mem)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Clock com período de 10 ns
    end

    // Teste inicial
    initial begin
        // Inicializações
        reset = 1;
        mem_to_reg_in = 0;
        reg_write_in = 0;
        mem_read_in = 0;
        mem_write_in = 0;
        beq_instruction_in = 0;
        alu_result_in = 0;
        mux2_result_in = 0;
        flag_beq_in = 0;
        reg_rd_in = 0;

        // Reset ativo por um ciclo
        #10 reset = 0;

        // Teste 1: Escrita na memória
        mem_write_in = 1;
        alu_result_in = 32'd8;       // Endereço de escrita
        mux2_result_in = 32'd12345; // Valor a ser escrito
        #10;

        // Teste 2: Leitura da memória
        mem_write_in = 0;
        mem_read_in = 1;
        alu_result_in = 32'd8; // Endereço a ser lido
        #10;

        // Teste 3: Instrução de branch
        mem_read_in = 0;
        beq_instruction_in = 1;
        flag_beq_in = 1; // Flag indica igualdade
        #10;

        // Teste 4: Forwarding Unit
        mem_read_in = 0;
        beq_instruction_in = 0;
        reg_write_in = 1;
        reg_rd_in = 5'd10;
        alu_result_in = 32'd56789;
        #10;

        // Encerrando a simulação
        $finish;
    end

    // Monitoramento das variáveis
    initial begin
        $monitor("Time=%0t | pcSrc=%b | read_data_out=%d | alu_result_out=%d | reg_rd_out=%d | ex_mem_reg_write=%b | alu_ex_mem=%d",
                 $time, pcSrc, uut.read_data_out, uut.alu_result_out, uut.reg_rd_out, uut.ex_mem_reg_write, uut.alu_ex_mem);
    end

endmodule