module control_unit_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg [6:0] instr_opcode;
    wire mem_read_en;
    wire mem_write_en;
    wire reg_write_en;
    wire branch_flag;
    wire [1:0] alu_ctrl;
    wire [1:0] mux_a_sel;
    wire [1:0] mux_b_sel;
    wire [1:0] mux_data_sel;

    // Instantiate the design under test (DUT)
    control_unit dut (
        .clk(clk),
        .rst(rst),
        .instr_opcode(instr_opcode),
        .mem_read_en(mem_read_en),
        .mem_write_en(mem_write_en),
        .reg_write_en(reg_write_en),
        .branch_flag(branch_flag),
        .alu_ctrl(alu_ctrl),
        .mux_a_sel(mux_a_sel),
        .mux_b_sel(mux_b_sel),
        .mux_data_sel(mux_data_sel)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns period
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        rst = 1;
        instr_opcode = 7'b0;

        // Apply reset
        #10 rst = 0;

        // Test R-type instruction
        instr_opcode = 7'b0110011;
        #10;
        $display("R-type: mem_read_en=%b, mem_write_en=%b, reg_write_en=%b, alu_ctrl=%b, mux_a_sel=%b, mux_b_sel=%b, mux_data_sel=%b, branch_flag=%b",
                 mem_read_en, mem_write_en, reg_write_en, alu_ctrl, mux_a_sel, mux_b_sel, mux_data_sel, branch_flag);

        // Test I-type instruction
        instr_opcode = 7'b0000011;
        #10;
        $display("I-type: mem_read_en=%b, mem_write_en=%b, reg_write_en=%b, alu_ctrl=%b, mux_a_sel=%b, mux_b_sel=%b, mux_data_sel=%b, branch_flag=%b",
                 mem_read_en, mem_write_en, reg_write_en, alu_ctrl, mux_a_sel, mux_b_sel, mux_data_sel, branch_flag);

        // Test S-type instruction
        instr_opcode = 7'b0100011;
        #10;
        $display("S-type: mem_read_en=%b, mem_write_en=%b, reg_write_en=%b, alu_ctrl=%b, mux_a_sel=%b, mux_b_sel=%b, mux_data_sel=%b, branch_flag=%b",
                 mem_read_en, mem_write_en, reg_write_en, alu_ctrl, mux_a_sel, mux_b_sel, mux_data_sel, branch_flag);

        // Test SB-type instruction
        instr_opcode = 7'b1100011;
        #10;
        $display("SB-type: mem_read_en=%b, mem_write_en=%b, reg_write_en=%b, alu_ctrl=%b, mux_a_sel=%b, mux_b_sel=%b, mux_data_sel=%b, branch_flag=%b",
                 mem_read_en, mem_write_en, reg_write_en, alu_ctrl, mux_a_sel, mux_b_sel, mux_data_sel, branch_flag);

        // Test unknown opcode
        instr_opcode = 7'b1111111;
        #10;
        $display("Unknown: mem_read_en=%b, mem_write_en=%b, reg_write_en=%b, alu_ctrl=%b, mux_a_sel=%b, mux_b_sel=%b, mux_data_sel=%b, branch_flag=%b",
                 mem_read_en, mem_write_en, reg_write_en, alu_ctrl, mux_a_sel, mux_b_sel, mux_data_sel, branch_flag);

        // End simulation
        $finish;
    end

endmodule
