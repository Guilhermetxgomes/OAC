module alu_control(
    input  [6:0] funct7,
    input  [2:0] funct3,
    input  [1:0] aluOp,
    output reg [3:0] op
);

    // Lista de operações
    // op = 0010 : add
    // op = 0110 : sub
    // op = 0000 : and
    // op = 0001 : or

    always @(*) begin
        case (aluOp)
            2'b00: begin
                op <= 4'b0010; //add (ld e sd)
            end 
            2'b01: begin
                op <= 4'b0110; // sub (beq)
            end
            2'b10:begin
                case (funct7)
                    7'b0100000: begin
                        op <= 4'b0110; // sub
                    end
                    7'b0000000: begin
                        case (funct3)
                            3'b000: begin
                                op <= 4'b0010; // add
                            end 
                            3'b110: begin
                                op <= 4'b0001; // or
                            end
                            3'b111: begin
                                op <= 4'b0000; // and
                            end
                            default: begin
                                op <= 4'b0010;
                            end
                        endcase
                    end 
                    default: begin
                        op <= 4'b0010;
                    end
                endcase
            end
            default: begin
                op <= 4'b0010;
            end
        endcase
    end

endmodule