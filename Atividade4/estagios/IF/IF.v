`include"estagios/IF/instruction_memory.v"
`include"estagios/IF/program_counter.v"
`include"registradores_estagios/if_id_register.v"

module fetch (
  input clock,
  input reset,
  input [31:0] pc_branch_value,
  input mux_sel,
  input load_pc,
  input load_if_id_register,
  input if_flush,
  output [31:0] pc_out,
  output [31:0] instrucao
);

  wire [31:0] pc_in_interno = 32'b0;
  wire [31:0] pc_out_interno, instrucao_interno;

  mux_2_values #(
    .WIDTH(32)
  ) mux_instruction_fetch (
    .sel(mux_sel),
    .D0(pc_out_interno + 32'd4),
    .D1(pc_branch_value),
    .D_out(pc_in_interno)
  );

  program_counter pc (
    .clock(clock),
    .reset(reset),
    .load(load_pc),
    .pc_in(pc_in_interno),
    .pc_out(pc_out_interno)
  );

  instruction_memory im (
    .addr(pc_out_interno),
    .instr(instrucao_interno)
  );


  if_id_register if_id_register(
    .clock(clock),
    .reset(reset),
    .load(load_if_id_register),
    .if_flush(if_flush),
    .pc_in(pc_in_interno),
    .instruction_memory_in(instrucao_interno),
    .pc_out(pc_out),
    .instruction(instrucao)
  );





endmodule
