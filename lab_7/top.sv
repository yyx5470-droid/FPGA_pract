module top (
  input  logic clk_in,
  input  logic rst,
  input  logic wr_en,
  input  logic [7:0] wr_data,
  output logic full,
  input  logic rd_en,
  output logic [7:0] rd_data,
  output logic empty,
  output logic pll_locked
);

  logic clk_a;
  logic clk_b;

  clk_wiz_0 clk_wiz (
    .clk_in1   (clk_in),
    .reset     (rst),
    .clk_out1 (clk_a),
    .clk_out2 (clk_b),
    .locked    (pll_locked)
  );

  async_fifo #(
    .DATA_WIDTH (8),
    .DEPTH      (16)
  ) fifo_inst (
    .wr_clk  (clk_a),
    .rd_clk  (clk_b),
    .rst     (rst | ~pll_locked),
    .wr_en   (wr_en),
    .wr_data (wr_data),
    .full    (full),
    .rd_en   (rd_en),
    .rd_data (rd_data),
    .empty   (empty)
  );

endmodule
