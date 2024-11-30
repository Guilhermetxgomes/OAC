module pc(
    input clock,
    input reset,
    input load,
    input [31:0] pc_in,
    output [31:0] pc_out
);

reg [31:0] pc_value;
    always @(negedge clock) begin
        if(reset) begin
            pc_value <= 32'b0;
        end else if(load) begin
            pc_value <= pc_in;
        end else begin
            pc_value <= pc_value;
        end
    end

assign pc_out = pc_value;

endmodule
