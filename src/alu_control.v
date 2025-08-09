`timescale 1ns / 1ps

module alu_control(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7,
    output reg [3:0] alu_control_out
);

always @(*) begin
    case (ALUOp)
        2'b00: begin // Load/Store
            alu_control_out = 4'b0000; // ADD
        end
        2'b01: begin // Branch
            alu_control_out = 4'b0001; // SUB
        end
        2'b10: begin // R-type/I-type
            case (funct3)
                3'b000: begin
                    if (funct7) 
                        alu_control_out = 4'b0001; // SUB
                    else 
                        alu_control_out = 4'b0000; // ADD
                end
                3'b111: alu_control_out = 4'b0010; // AND
                3'b110: alu_control_out = 4'b0011; // OR
                3'b010: alu_control_out = 4'b0100; // SLT
                3'b001: alu_control_out = 4'b0101; // SLL
                3'b101: begin
                    if (funct7)
                        alu_control_out = 4'b0111; // SRA
                    else
                        alu_control_out = 4'b0110; // SRL
                end
                default: alu_control_out = 4'b0000;
            endcase
        end
        default: alu_control_out = 4'b0000;
    endcase
end

endmodule