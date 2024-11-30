module instruction_memory_tb;
  reg [31:0] addr;
  wire [31:0] instr;

  // Instanciar a memória de instruções
  instruction_memory im (
    .addr(addr),
    .instr(instr)
  );

  initial begin
    // Testar alguns endereços
    $display("Teste da Memória de Instruções:");
    addr = 32'h000; #10;
    $display("Addr: %h, Instr: %b", addr, instr);

    addr = 32'h004; #10;
    $display("Addr: %h, Instr: %b", addr, instr);

    addr = 32'h008; #10;
    $display("Addr: %h, Instr: %b", addr, instr);

    addr = 32'h00C; #10;
    $display("Addr: %h, Instr: %b", addr, instr);

    addr = 32'h010; #10;
    $display("Addr: %h, Instr: %b", addr, instr);

    addr = 32'h014; #10;
    $display("Addr: %h, Instr: %b", addr, instr);

    addr = 32'h018; #10;
    $display("Addr: %h, Instr: %b", addr, instr);

    addr = 32'h01C; #10;
    $display("Addr: %h, Instr: %b", addr, instr);

    $finish;
  end
endmodule
