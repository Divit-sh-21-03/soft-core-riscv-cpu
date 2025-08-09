`timescale 1ns / 1ps

module imm_gen(
    input [31:0] instruction,
    output reg [31:0] immediate
);

wire [6:0] opcode = instruction[6:0];

always @(*) begin
    case (opcode)
        7'b0010011: begin // I-type (ADDI, ANDI, ORI, SLTI, SLLI, SRLI, SRAI)
            immediate = {{20{instruction[31]}}, instruction[31:20]};
        end
        7'b0000011: begin // I-type (Load)
            immediate = {{20{instruction[31]}}, instruction[31:20]};
        end
        7'b0100011: begin // S-type (Store)
            immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end
        7'b1100011: begin // B-type (Branch)
            immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        end
        7'b0110111: begin // U-type (LUI)
            immediate = {instruction[31:12], 12'b0};
        end
        7'b1101111: begin // J-type (JAL)
            immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        end
        default: begin
            immediate = 32'b0;
        end
    endcase
end

endmodule