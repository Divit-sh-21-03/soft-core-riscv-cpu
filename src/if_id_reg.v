`timescale 1ns / 1ps

module if_id_reg(
    input clk,rst,IF_ID_Write,flush,
    input [31:0] pc_in,instruction_in,
    output reg [31:0] pc_out,instruction_out
);

always @(posedge clk or posedge rst) begin
    if (rst || flush) begin
        pc_out <= 32'b0;
        instruction_out <= 32'h00000013; // NOP
    end
    else if (IF_ID_Write) begin
        pc_out <= pc_in;
        instruction_out <= instruction_in;
    end
    // If IF_ID_Write is low, register maintains its current values (stall)
end

endmodule

