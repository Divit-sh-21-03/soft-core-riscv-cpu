`timescale 1ns / 1ps

module mem_wb_reg(
    input clk,
    input rst,
    // Control signals
    input RegWrite_in,
    input MemToReg_in,
    // Data
    input [31:0] alu_result_in,
    input [31:0] mem_data_in,
    input [4:0] rd_in,
    input [31:0] instruction_in,
    // Outputs
    output reg RegWrite_out,
    output reg MemToReg_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] mem_data_out,
    output reg [4:0] rd_out,
    output reg [31:0] instruction_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        RegWrite_out <= 1'b0;
        MemToReg_out <= 1'b0;
        alu_result_out <= 32'b0;
        mem_data_out <= 32'b0;
        rd_out <= 5'b0;
        instruction_out <= 32'h00000013; // NOP
    end
    else begin
        RegWrite_out <= RegWrite_in;
        MemToReg_out <= MemToReg_in;
        alu_result_out <= alu_result_in;
        mem_data_out <= mem_data_in;
        rd_out <= rd_in;
        instruction_out <= instruction_in;
    end
end

endmodule