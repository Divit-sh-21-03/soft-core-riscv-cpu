`timescale 1ns / 1ps

module control_unit(
    input [6:0] opcode,
    output reg RegWrite,MemRead,MemWrite,Branch,ALUSrc,MemToReg,
    output reg [1:0] ALUOp
);

always @(*) begin
    // Default values
    RegWrite = 1'b0;
    MemRead = 1'b0;
    MemWrite = 1'b0;
    Branch = 1'b0;
    ALUSrc = 1'b0;
    MemToReg = 1'b0;
    ALUOp = 2'b00;
    
    case (opcode)
        7'b0110011: begin // R-type (ADD, SUB, AND, OR, SLL, SRL, SRA, SLT)
            RegWrite = 1'b1;
            ALUOp = 2'b10;
        end
        7'b0010011: begin // I-type (ADDI, ANDI, ORI, SLTI, SLLI, SRLI, SRAI)
            RegWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 2'b10;
        end
        7'b0000011: begin // Load (LW)
            RegWrite = 1'b1;
            MemRead = 1'b1;
            ALUSrc = 1'b1;
            MemToReg = 1'b1;
            ALUOp = 2'b00;
        end
        7'b0100011: begin // Store (SW)
            MemWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 2'b00;
        end
        7'b1100011: begin // Branch (BEQ, BNE)
            Branch = 1'b1;
            ALUOp = 2'b01;
        end
        default: begin
            // NOP or unsupported inst
        end
    endcase
end

endmodule