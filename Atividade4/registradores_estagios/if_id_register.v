module if_id_register (
  input clock,
  input reset,
  input load,
  input [31:0] pc_in,
  input [31:0] instruction_memory_in,
  output [31:0] pc_out,
  output [31:0] instruction
);

reg [31:0] pc_value;
reg [31:0] im_value;
    always @(negedge clock) begin
        if(reset) begin
            pc_value <= 32'b0;
            im_value <= 32'b0;
        end else if(load) begin
            pc_value <= pc_in;
            im_value <= instruction_memory_in;
        end else begin
            pc_value <= pc_value;
            im_value <= im_value;
        end
    end

assign pc_out = pc_value;
assign instruction = im_value;


endmodule
