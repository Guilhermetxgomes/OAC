module decode_tb();
    reg clock;
    reg reset;
    reg write_enable;
    reg [31:0] instruction;
    reg [31:0] pc;
    reg [31:0] Din;
    reg [4:0] dest_ex_mem, dest_mem_wb, reg_destino_exe;

    wire pc_enable, if_id_enable;
    wire mem_to_reg_out, reg_write_out, mem_read_out;
    wire mem_write_out, beq_instruction_out, aluSrc_out;
    wire [1:0] aluOp_out;
    wire [4:0] rs1_out, rs2_out, rd_out;
    wire [31:0] imediato_out, pc_branch_value;
    wire mux_sel_IF;

    // Instância do módulo decode
    decode uut (
        .clock(clock),
        .reset(reset),
        .write_enable(write_enable),
        .instruction(instruction),
        .pc(pc),
        .Din(Din),
        .dest_ex_mem(dest_ex_mem),
        .dest_mem_wb(dest_mem_wb),
        .reg_destino_exe(reg_destino_exe),
        .pc_enable(pc_enable),
        .if_id_enable(if_id_enable),
        .mem_to_reg_out(mem_to_reg_out),
        .reg_write_out(reg_write_out),
        .mem_read_out(mem_read_out),
        .mem_write_out(mem_write_out),
        .beq_instruction_out(beq_instruction_out),
        .aluSrc_out(aluSrc_out),
        .aluOp_out(aluOp_out),
        .rs1_out(rs1_out),
        .rs2_out(rs2_out),
        .rd_out(rd_out),
        .imediato_out(imediato_out),
        .pc_branch_value(pc_branch_value),
        .mux_sel_IF(mux_sel_IF)
    );

    // Clock generator
    always #5 clock = ~clock;

    initial begin
        $display("Iniciando Testbench...");

        // Inicialização
        clock = 0;
        reset = 1;
        write_enable = 0;
        instruction = 0;
        pc = 0;
        Din = 0;
        dest_ex_mem = 0;
        dest_mem_wb = 0;
        reg_destino_exe = 0;
        #10 reset = 0;

        // Teste 1: Instrução do tipo R (add x5, x6, x7)
        instruction = 32'b0000000_00110_00111_000_00101_0110011;
        pc = 32'h10;
        #10;
        $display("Teste Tipo R:");
        $display("rs1_out: %d, rs2_out: %d, rd_out: %d, pc_branch_value: %h", rs1_out, rs2_out, rd_out, pc_branch_value);

        // Teste 2: Instrução do tipo SB (beq x1, x2, offset = 0x8)
        instruction = 32'b0000000_00010_00001_000_00100_1100011;
        pc = 32'h20;
        #10;
        $display("Teste Tipo SB:");
        $display("mux_sel_IF: %b, pc_branch_value: %h", mux_sel_IF, pc_branch_value);

        // Teste 3: Hazard de dados entre dest_ex_mem e rs1
        dest_ex_mem = 5'd1;
        instruction = 32'b0000000_00001_00010_000_00011_0110011; // rs1 = dest_ex_mem
        #10;
        $display("Teste Hazard de Dados:");
        $display("pc_enable: %b, if_id_enable: %b (indicam efeito de stall_pipeline)", pc_enable, if_id_enable);

        // Teste 4: Instrução do tipo I (lw x4, 0(x3))
        instruction = 32'b0000000_00011_00011_010_00100_0000011; // imediato = 0, rs1 = 3, rd = 4
        pc = 32'h30;
        #10;
        $display("Teste Tipo I:");
        $display("rs1_out: %d, rd_out: %d, imediato_out: %h", rs1_out, rd_out, imediato_out);

        // Teste 5: Hazard de dados entre dest_mem_wb e rs2
        dest_mem_wb = 5'd2;
        instruction = 32'b0000000_00010_00001_000_00100_0100011; // rs2 = dest_mem_wb
        #10;
        $display("Teste Hazard de Dados 2:");
        $display("pc_enable: %b, if_id_enable: %b (indicam efeito de stall_pipeline)", pc_enable, if_id_enable);

        // Finalização
        $display("Finalizando Testbench...");
        $finish;
    end
endmodule
