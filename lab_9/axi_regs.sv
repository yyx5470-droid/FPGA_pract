module axi_regs #(
  parameter int ADDR_WIDTH = 8,
  parameter int DATA_WIDTH = 32
)(
  input  logic                  aclk,
  input  logic                  aresetn,

  input  logic [ADDR_WIDTH-1:0] awaddr,
  input  logic                  awvalid,
  output logic                  awready,

  input  logic [DATA_WIDTH-1:0] wdata,
  input  logic [DATA_WIDTH/8-1:0] wstrb,
  input  logic                  wvalid,
  output logic                  wready,

  output logic [1:0]            bresp,
  output logic                  bvalid,
  input  logic                  bready,

  input  logic [ADDR_WIDTH-1:0] araddr,
  input  logic                  arvalid,
  output logic                  arready,

  output logic [DATA_WIDTH-1:0] rdata,
  output logic [1:0]            rresp,
  output logic                  rvalid,
  input  logic                  rready
);

  logic [DATA_WIDTH-1:0] regs [0:7];

  logic [ADDR_WIDTH-1:0] awaddr_ff;
  logic                  aw_done;
  logic [DATA_WIDTH-1:0] wdata_ff;
  logic [DATA_WIDTH/8-1:0] wstrb_ff;
  logic                  w_done;

  logic [ADDR_WIDTH-1:0] araddr_ff;

  logic addr_ok;
  logic ar_ok;
  logic [2:0] idx;
  logic [2:0] ar_idx;

  assign addr_ok = (awaddr_ff[1:0] == 2'b00) && (awaddr_ff[7:5] == 3'b000);
  assign ar_ok   = (araddr_ff[1:0] == 2'b00) && (araddr_ff[7:5] == 3'b000);
  assign idx     = awaddr_ff[4:2];
  assign ar_idx  = araddr_ff[4:2];

  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      for (int i = 0; i < 8; i++)
        regs[i] <= '0;

      awaddr_ff <= '0;
      aw_done   <= 1'b0;
      wdata_ff  <= '0;
      wstrb_ff  <= '0;
      w_done    <= 1'b0;
      bvalid    <= 1'b0;
      bresp     <= 2'b00;

      araddr_ff <= '0;
      rvalid    <= 1'b0;
      rdata     <= '0;
      rresp     <= 2'b00;
    end else begin
      if (awvalid && awready) begin
        awaddr_ff <= awaddr;
        aw_done   <= 1'b1;
      end

      if (wvalid && wready) begin
        wdata_ff <= wdata;
        wstrb_ff <= wstrb;
        w_done   <= 1'b1;
      end

      if (aw_done && w_done && !bvalid) begin
        bvalid <= 1'b1;
        if (addr_ok) begin
          bresp <= 2'b00;
          if (wstrb_ff[0]) regs[idx][7:0]   <= wdata_ff[7:0];
          if (wstrb_ff[1]) regs[idx][15:8]  <= wdata_ff[15:8];
          if (wstrb_ff[2]) regs[idx][23:16] <= wdata_ff[23:16];
          if (wstrb_ff[3]) regs[idx][31:24] <= wdata_ff[31:24];
        end else begin
          bresp <= 2'b11;
        end
      end

      if (bvalid && bready) begin
        bvalid  <= 1'b0;
        aw_done <= 1'b0;
        w_done  <= 1'b0;
      end

      if (arvalid && arready) begin
        araddr_ff <= araddr;
        rvalid    <= 1'b1;
        if (ar_ok) begin
          rdata <= regs[ar_idx];
          rresp <= 2'b00;
        end else begin
          rdata <= '0;
          rresp <= 2'b11;
        end
      end

      if (rvalid && rready) begin
        rvalid <= 1'b0;
      end
    end
  end

  always_comb begin
    awready = !aw_done;
    wready  = !w_done;
    arready = !rvalid;
  end

endmodule
