`timescale 1ns / 1ps

module lab2_lut_fdce (
  input  [3:0] a,
  input  [3:0] b,
  input  [3:0] c,
  input        clk,
  input        ce,
  input        rst,
  output [3:0] q
);

wire [3:0] y;

LUT3 #(.INIT(8'h56))
lut0 (
  .O  (y[0]),
  .I0 (a[0]),
  .I1 (b[0]),
  .I2 (c[0])
);

LUT3 #(.INIT(8'h56))
lut1 (
  .O  (y[1]),
  .I0 (a[1]),
  .I1 (b[1]),
  .I2 (c[1])
);

LUT3 #(.INIT(8'h56))
lut2 (
  .O  (y[2]),
  .I0 (a[2]),
  .I1 (b[2]),
  .I2 (c[2])
);

LUT3 #(.INIT(8'h56))
lut3 (
  .O  (y[3]),
  .I0 (a[3]),
  .I1 (b[3]),
  .I2 (c[3])
);

FDCE #(.INIT(1'b0))
ff0(
  .Q   (q[0]),
  .C   (clk),
  .CE  (ce),
  .CLR (rst),
  .D   (y[0])
);

FDCE #(.INIT(1'b0))
ff1(
  .Q   (q[1]),
  .C   (clk),
  .CE  (ce),
  .CLR (rst),
  .D   (y[1])
);

FDCE #(.INIT(1'b0))
ff2(
  .Q   (q[2]),
  .C   (clk),
  .CE  (ce),
  .CLR (rst),
  .D   (y[2])
);

FDCE #(.INIT(1'b0))
ff3(
  .Q   (q[3]),
  .C   (clk),
  .CE  (ce),
  .CLR (rst),
  .D   (y[3])
);

endmodule