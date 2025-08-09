`timescale 1ns / 1ps

module ex_mem_reg(
    input clk,
    input rst,
    // Control signals
    input RegWrite_in,MemRead_in,MemWrite_in,MemToReg_in,
    // Data
    input [31:0] alu_result_in,write_data_in,instruction_in,
    input [4:0] rd_in,
    // Outputs
    output reg RegWrite_out,MemRead_out,MemWrite_out,MemToReg_out,
    output reg [31:0] alu_result_out,write_data_out,instruction_out,
    output reg [4:0] rd_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        RegWrite_out <= 1'b0;
        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        MemToReg_out <= 1'b0;
        alu_result_out <= 32'b0;
        write_data_out <= 32'b0;
        rd_out <= 5'b0;
        instruction_out <= 32'h00000013; // NOP
    end
    else begin
        RegWrite_out <= RegWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        MemToReg_out <= MemToReg_in;
        alu_result_out <= alu_result_in;
        write_data_out <= write_data_in;
        rd_out <= rd_in;
        instruction_out <= instruction_in;
    end
end

endmodule