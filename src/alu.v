`timescale 1ns / 1ps

module alu(
    input [31:0] a,b,
    input [3:0] alu_control,
    output reg [31:0] result,
    output zero
);

always @(*) begin
    case (alu_control)
        4'b0000: result = a + b;       
        4'b0001: result = a - b;        
        4'b0010: result = a & b;        
        4'b0011: result = a | b;        
        4'b0100: result = ($signed(a) < $signed(b)) ? 1 : 0;  // SLT
        4'b0101: result = b << a[4:0];  // SLL (shift left logical)
        4'b0110: result = b >> a[4:0];  // SRL (shift right logical)
        4'b0111: result = $signed(b) >>> a[4:0];  // SRA (shift right arithmetic)
        default: result = 32'b0;
    endcase
end

assign zero = (result == 32'b0);

endmodule
