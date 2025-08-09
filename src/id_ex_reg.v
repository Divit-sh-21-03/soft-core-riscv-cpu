`timescale 1ns / 1ps

module id_ex_reg(
    input clk,rst,flush,
    // Control signals
    input RegWrite_in,MemRead_in,MemWrite_in,Branch_in,ALUSrc_in,MemToReg_in,
    input [1:0] ALUOp_in,
    // Data
    input [31:0] pc_in,read_data1_in,read_data2_in,immediate_in,instruction_in,
    input [4:0] rs1_in,rs2_in,rd_in,
    input [2:0] funct3_in,
    input funct7_in,
    // Outputs
    output reg RegWrite_out,MemRead_out,MemWrite_out,Branch_out,ALUSrc_out,MemToReg_out,
    output reg [1:0] ALUOp_out,
    output reg [31:0] pc_out,read_data1_out,read_data2_out,immediate_out,
    output reg [4:0] rs1_out,rs2_out,rd_out,
    output reg [2:0] funct3_out,
    output reg funct7_out,
    output reg [31:0] instruction_out
);

always @(posedge clk or posedge rst) begin
    if (rst || flush) begin
        RegWrite_out <= 1'b0;
        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        Branch_out <= 1'b0;
        ALUSrc_out <= 1'b0;
        MemToReg_out <= 1'b0;
        ALUOp_out <= 2'b00;
        pc_out <= 32'b0;
        read_data1_out <= 32'b0;
        read_data2_out <= 32'b0;
        immediate_out <= 32'b0;
        rs1_out <= 5'b0;
        rs2_out <= 5'b0;
        rd_out <= 5'b0;
        funct3_out <= 3'b0;
        funct7_out <= 1'b0;
        instruction_out <= 32'h00000013; // NOP
    end
    else begin
        RegWrite_out <= RegWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        Branch_out <= Branch_in;
        ALUSrc_out <= ALUSrc_in;
        MemToReg_out <= MemToReg_in;
        ALUOp_out <= ALUOp_in;
        pc_out <= pc_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        immediate_out <= immediate_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;
        funct3_out <= funct3_in;
        funct7_out <= funct7_in;
        instruction_out <= instruction_in;
    end
end

endmodule