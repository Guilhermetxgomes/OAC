module control_unit (
    input               clk,
    input               rst,
    input       [6:0]   instr_opcode,
    output reg          mem_read_en,
    output reg          mem_write_en,
    output reg          reg_write_en,
    output reg          branch_flag,
    output reg  [1:0]   alu_ctrl,
    output reg  [1:0]   mux_a_sel,
    output reg  [1:0]   mux_b_sel,
    output reg  [1:0]   mux_data_sel
);

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs to default values
            mem_read_en   <= 1'b0;
            mem_write_en  <= 1'b0;
            reg_write_en  <= 1'b0;
            branch_flag   <= 1'b0;
            alu_ctrl      <= 2'b00;
            mux_a_sel     <= 2'b00;
            mux_b_sel     <= 2'b00;
            mux_data_sel  <= 2'b00;
        end else begin
            // Decode the opcode and generate control signals
            case (instr_opcode)
                7'b0110011: begin // R-type instruction
                    mem_read_en   <= 1'b0;
                    mem_write_en  <= 1'b0;
                    reg_write_en  <= 1'b1;
                    alu_ctrl      <= 2'b10;
                    mux_a_sel     <= 2'b00;
                    mux_b_sel     <= 2'b01;
                    mux_data_sel  <= 2'b00;
                    branch_flag   <= 1'b0;
                end
                7'b0000011: begin // I-type instruction (load)
                    mem_read_en   <= 1'b1;
                    mem_write_en  <= 1'b0;
                    reg_write_en  <= 1'b1;
                    alu_ctrl      <= 2'b01;
                    mux_a_sel     <= 2'b01;
                    mux_b_sel     <= 2'b00;
                    mux_data_sel  <= 2'b00;
                    branch_flag   <= 1'b0;
                end
                7'b0100011: begin // S-type instruction (store)
                    mem_read_en   <= 1'b0;
                    mem_write_en  <= 1'b1;
                    reg_write_en  <= 1'b0;
                    alu_ctrl      <= 2'b00;
                    mux_a_sel     <= 2'b01;
                    mux_b_sel     <= 2'b00;
                    mux_data_sel  <= 2'b01;
                    branch_flag   <= 1'b0;
                end
                7'b1100011: begin // SB-type instruction (branch)
                    mem_read_en   <= 1'b0;
                    mem_write_en  <= 1'b0;
                    reg_write_en  <= 1'b0;
                    alu_ctrl      <= 2'b00;
                    mux_a_sel     <= 2'b00;
                    mux_b_sel     <= 2'b00;
                    mux_data_sel  <= 2'b00;
                    branch_flag   <= 1'b1;
                end
                default: begin // Default case for unknown opcodes
                    mem_read_en   <= 1'b0;
                    mem_write_en  <= 1'b0;
                    reg_write_en  <= 1'b0;
                    alu_ctrl      <= 2'b00;
                    mux_a_sel     <= 2'b00;
                    mux_b_sel     <= 2'b00;
                    mux_data_sel  <= 2'b00;
                    branch_flag   <= 1'b0;
                end
            endcase
        end
    end

endmodule
