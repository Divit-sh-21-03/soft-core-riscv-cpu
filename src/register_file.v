`timescale 1ns / 1ps

module register_file(
    input clk,rst,
    input [4:0] read_addr1,read_addr2,write_addr,
    input [31:0] write_data,
    input RegWrite,
    output [31:0] read_data1,read_data2
);

reg [31:0] registers [31:0];
integer i;

// Asynchronous read
assign read_data1 = (read_addr1 == 5'b0) ? 32'b0 : registers[read_addr1];
assign read_data2 = (read_addr2 == 5'b0) ? 32'b0 : registers[read_addr2];

// Synchronous write
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
        end
    end
    else if (RegWrite && (write_addr != 5'b0)) begin
        registers[write_addr] <= write_data;
    end
end

endmodule