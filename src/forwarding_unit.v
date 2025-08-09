`timescale 1ns / 1ps

module forwarding_unit(
    input [4:0] rs1_ex,rs2_ex,rd_mem,rd_wb,
    input RegWrite_mem,RegWrite_wb,
    output reg [1:0] ForwardA,ForwardB
);

always @(*) begin
    // Forward A (ALU input A)
    if (RegWrite_mem && (rd_mem != 5'b0) && (rd_mem == rs1_ex)) begin
        ForwardA = 2'b10; // Forward from MEM stage
    end
    else if (RegWrite_wb && (rd_wb != 5'b0) && (rd_wb == rs1_ex) && 
             !((RegWrite_mem && (rd_mem != 5'b0) && (rd_mem == rs1_ex)))) begin
        ForwardA = 2'b01; // Forward from WB stage
    end
    else begin
        ForwardA = 2'b00; // No forwarding
    end
    
    // Forward B (ALU input B)
    if (RegWrite_mem && (rd_mem != 5'b0) && (rd_mem == rs2_ex)) begin
        ForwardB = 2'b10; // Forward from MEM stage
    end
    else if (RegWrite_wb && (rd_wb != 5'b0) && (rd_wb == rs2_ex) && 
             !((RegWrite_mem && (rd_mem != 5'b0) && (rd_mem == rs2_ex)))) begin
        ForwardB = 2'b01; // Forward from WB stage
    end
    else begin
        ForwardB = 2'b00; // No forwarding
    end
end

endmodule