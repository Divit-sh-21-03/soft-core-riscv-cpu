`timescale 1ns/1ps

module instruction_memory (
    input [31:0] address,
    output [31:0] instruction  // Changed from 'inst' to 'instruction'
);

    // 1kb is 256 words (32*256)
    reg [31:0] mem [255:0];
    
    wire [7:0] word_addr = address[9:2];
    
    assign instruction = mem[word_addr];  // Changed signal name
    
    // initialize NOP inst
    integer i;
    initial begin
        for (i=0; i<256; i=i+1)
            mem[i] = 32'h00000013;
    end
    
    // Renamed task to match testbench call
    task load_instructions;
        input [255*8:0] filename;  // Changed input size to match testbench
        begin
            $readmemh(filename, mem);
        end
    endtask

endmodule
