module forwarding_unit(
    input [4:0] id_ex_reg_rs1,
    input [4:0] id_ex_reg_rs2,
    input       ex_mem_reg_write,
    input [4:0] ex_mem_reg_rd,
    input       mem_wb_reg_write,
    input [4:0] mem_wb_reg_rd,
    output [1:0] forwardA,
    output [1:0] forwardB
);

assign forwardA = (ex_mem_reg_write && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rs1)) ? 2'b10 : 
                  (mem_wb_reg_write && (mem_wb_reg_rd != 0) && (mem_wb_reg_rd == id_ex_reg_rs1)) ? 2'b01 :
                  2'b00;

assign forwardB = (ex_mem_reg_write && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rs2)) ? 2'b10 : 
                  (mem_wb_reg_write && (mem_wb_reg_rd != 0) && (mem_wb_reg_rd == id_ex_reg_rs2)) ? 2'b01 :
                  2'b00;                  

endmodule