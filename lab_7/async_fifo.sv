module async_fifo #(
  parameter DATA_WIDTH = 8,
  parameter DEPTH      = 16,
  parameter ADDR_WIDTH = $clog2(DEPTH)
)(
  input  logic                  wr_clk,
  input  logic                  rd_clk,
  input  logic                  rst,
  input  logic                  wr_en,
  input  logic [DATA_WIDTH-1:0] wr_data,
  output logic                  full,
  input  logic                  rd_en,
  output logic [DATA_WIDTH-1:0] rd_data,
  output logic                  empty
);

  logic [DATA_WIDTH-1:0] mem [DEPTH];

  logic [ADDR_WIDTH:0] wr_ctr;
  logic [ADDR_WIDTH:0] rd_ctr;

  logic [ADDR_WIDTH:0] wr_gray;
  logic [ADDR_WIDTH:0] rd_gray;

  logic [ADDR_WIDTH:0] rd_sync [2];
  logic [ADDR_WIDTH:0] wr_sync [2];

  always_ff @(posedge wr_clk or posedge rst) begin
    if (rst) begin
      wr_ctr <= '0;
    end else if (wr_en && !full) begin
      mem[wr_ctr[ADDR_WIDTH-1:0]] <= wr_data;
      wr_ctr <= wr_ctr + 1'b1;
    end
  end

  assign wr_gray = (wr_ctr >> 1) ^ wr_ctr;

  always_ff @(posedge wr_clk or posedge rst) begin
    if (rst) begin
      rd_sync[0] <= '0;
      rd_sync[1] <= '0;
    end else begin
      rd_sync[0] <= rd_gray;
      rd_sync[1] <= rd_sync[0];
    end
  end

  assign full = (wr_gray == {~rd_sync[1][ADDR_WIDTH:ADDR_WIDTH-1], rd_sync[1][ADDR_WIDTH-2:0]});

  always_ff @(posedge rd_clk or posedge rst) begin
    if (rst) begin
      rd_ctr <= '0;
    end else if (rd_en && !empty) begin
      rd_ctr <= rd_ctr + 1'b1;
    end
  end

  assign rd_data = mem[rd_ctr[ADDR_WIDTH-1:0]];

  assign rd_gray = (rd_ctr >> 1) ^ rd_ctr;

  always_ff @(posedge rd_clk or posedge rst) begin
    if (rst) begin
      wr_sync[0] <= '0;
      wr_sync[1] <= '0;
    end else begin
      wr_sync[0] <= wr_gray;
      wr_sync[1] <= wr_sync[0];
    end
  end

  assign empty = (rd_gray == wr_sync[1]);

endmodule