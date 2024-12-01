module mux_2_values #(
    parameter WIDTH = 32
) (
    input  sel,
    input  [WIDTH-1:0]    D0,
    input  [WIDTH-1:0]    D1,
    output [WIDTH-1:0]    D_out
);

assign D_out = ( sel == 1'b1   ) ? D1 : D0;

endmodule
