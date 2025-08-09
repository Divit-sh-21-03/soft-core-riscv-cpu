`timescale 1ns / 1ps

module data_memory(
    input [31:0] address,write_data,
    input MemRead,MemWrite,clk,
    output reg [31:0] read_data
);

// 1KB memory (256 words)
reg [31:0] mem [255:0];
wire [7:0] word_addr = address[9:2]; // Word-aligned addressing

integer i;
initial begin
    for (i = 0; i < 256; i = i + 1) begin
        mem[i] = 32'b0;
    end
end

always @(posedge clk) begin
    if (MemWrite) begin
        mem[word_addr] <= write_data;
    end
end

always @(*) begin
    if (MemRead) begin
        read_data = mem[word_addr];
    end
    else begin
        read_data = 32'b0;
    end
end

endmodule