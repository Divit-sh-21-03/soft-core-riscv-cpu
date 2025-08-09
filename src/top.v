// top_level.v
module top_level(
  input  clk,
  input  rst,
  output [7:0] led
);
  pipeline_core cpu (
    .clk(clk),
    .rst(rst),
    .led(led)
  );
endmodule
