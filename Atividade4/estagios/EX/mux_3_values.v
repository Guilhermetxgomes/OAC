module mux_3_values #(
    parameter WIDTH = 32
) (
    input  [1:0]          sel,
    input  [WIDTH-1:0]    D0,
    input  [WIDTH-1:0]    D1,
    input  [WIDTH-1:0]    D2,
    output [WIDTH-1:0]    D_out
);

assign D_out = ( sel == 2'b00   ) ? D0 : 
               ( sel == 2'b01   ) ? D1 :        
               ( sel == 2'b10   ) ? D2 : D0;

endmodule
