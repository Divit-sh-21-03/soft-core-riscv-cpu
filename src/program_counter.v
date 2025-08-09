`timescale 1ns / 1ps

module program_counter(
    input clk,rst,PCWrite,
    input [31:0] pc_next,
    output reg [31:0] pc_current
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_current <= 32'b0;
    end
    else if (PCWrite) begin
        pc_current <= pc_next;
    end
    // If PCWrite is low, PC maintains its current value (stall)
end

endmodule