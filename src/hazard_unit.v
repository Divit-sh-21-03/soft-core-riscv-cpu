`timescale 1ns / 1ps

module hazard_unit(
    input [4:0] rs1_id,rd_ex,rs2_id,
    input MemRead_ex,branch_taken,
    output reg PCWrite,IF_ID_Write,Control_flush
);

always @(*) begin
    // Default values
    PCWrite = 1'b1;
    IF_ID_Write = 1'b1;
    Control_flush = 1'b0;
    
    // Load-use hazard detection
    if (MemRead_ex && (rd_ex != 5'b0) && 
        ((rd_ex == rs1_id) || (rd_ex == rs2_id))) begin
        PCWrite = 1'b0;      // Stall PC
        IF_ID_Write = 1'b0;  // Stall IF/ID register
        Control_flush = 1'b1; // Flush control signals (insert bubble)
    end
    
    // Branch hazard - flush pipeline on branch taken
    if (branch_taken) begin
        Control_flush = 1'b1; // Flush IF/ID and ID/EX stages
    end
end

endmodule