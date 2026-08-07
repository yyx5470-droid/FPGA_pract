`timescale 1ns / 1ps

module tb_lab2;

reg [3:0] a,b,c;
reg       clk;
reg       ce;
reg       rst;

wire [3:0] q;

lab2_lut_fdce dut(
  .a   (a),
  .b   (b),
  .c   (c),
  .clk (clk),
  .ce  (ce),
  .rst (rst),
  .q   (q)
);

initial begin
  clk = 0;
  forever #5 clk = ~clk;
end

initial begin

  a=0;
  b=0;
  c=0;
  ce=0;
  rst=1;

  #200;

  rst=0;

  a=4'b0101;
  b=4'b0011;
  c=4'b0000;
  ce=1;

  @(posedge clk);
  #1;

  $display("T1 y=%b q=%b",a^(b|c),q);

  a=4'b1111;
  b=4'b0000;
  c=4'b1111;

  @(posedge clk);
  #1;

  $display("T2 y=%b q=%b",a^(b|c),q);

  ce=0;

  a=4'b1010;
  b=4'b0101;
  c=4'b0000;

  @(posedge clk);
  #1;

  $display("T3 q=%b",q);

  rst=1;
  #20;
  rst=0;
  #2;

  $display("T4 q=%b",q);

  ce=1;

  a=4'b1100;
  b=4'b1010;
  c=4'b0101;

  @(posedge clk);
  #1;

  $display("T5 y=%b q=%b",a^(b|c),q);

  #20;
  $finish;

end

endmodule