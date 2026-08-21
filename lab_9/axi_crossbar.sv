module axi_crossbar #(
  parameter int ADDR_WIDTH = 16,
  parameter int DATA_WIDTH = 32
)(
  input  logic                          aclk,
  input  logic                          aresetn,

  input  logic [ADDR_WIDTH-1:0]         m0_awaddr,
  input  logic                          m0_awvalid,
  output logic                          m0_awready,

  input  logic [DATA_WIDTH-1:0]         m0_wdata,
  input  logic [DATA_WIDTH/8-1:0]       m0_wstrb,
  input  logic                          m0_wvalid,
  output logic                          m0_wready,

  output logic [1:0]                    m0_bresp,
  output logic                          m0_bvalid,
  input  logic                          m0_bready,

  input  logic [ADDR_WIDTH-1:0]         m0_araddr,
  input  logic                          m0_arvalid,
  output logic                          m0_arready,

  output logic [DATA_WIDTH-1:0]         m0_rdata,
  output logic [1:0]                    m0_rresp,
  output logic                          m0_rvalid,
  input  logic                          m0_rready,

  input  logic [ADDR_WIDTH-1:0]         m1_awaddr,
  input  logic                          m1_awvalid,
  output logic                          m1_awready,

  input  logic [DATA_WIDTH-1:0]         m1_wdata,
  input  logic [DATA_WIDTH/8-1:0]       m1_wstrb,
  input  logic                          m1_wvalid,
  output logic                          m1_wready,

  output logic [1:0]                    m1_bresp,
  output logic                          m1_bvalid,
  input  logic                          m1_bready,

  input  logic [ADDR_WIDTH-1:0]         m1_araddr,
  input  logic                          m1_arvalid,
  output logic                          m1_arready,

  output logic [DATA_WIDTH-1:0]         m1_rdata,
  output logic [1:0]                    m1_rresp,
  output logic                          m1_rvalid,
  input  logic                          m1_rready,

  output logic [ADDR_WIDTH-1:0]         s0_awaddr,
  output logic                          s0_awvalid,
  input  logic                          s0_awready,

  output logic [DATA_WIDTH-1:0]         s0_wdata,
  output logic [DATA_WIDTH/8-1:0]       s0_wstrb,
  output logic                          s0_wvalid,
  input  logic                          s0_wready,

  input  logic [1:0]                    s0_bresp,
  input  logic                          s0_bvalid,
  output logic                          s0_bready,

  output logic [ADDR_WIDTH-1:0]         s0_araddr,
  output logic                          s0_arvalid,
  input  logic                          s0_arready,

  input  logic [DATA_WIDTH-1:0]         s0_rdata,
  input  logic [1:0]                    s0_rresp,
  input  logic                          s0_rvalid,
  output logic                          s0_rready,

  output logic [ADDR_WIDTH-1:0]         s1_awaddr,
  output logic                          s1_awvalid,
  input  logic                          s1_awready,

  output logic [DATA_WIDTH-1:0]         s1_wdata,
  output logic [DATA_WIDTH/8-1:0]       s1_wstrb,
  output logic                          s1_wvalid,
  input  logic                          s1_wready,

  input  logic [1:0]                    s1_bresp,
  input  logic                          s1_bvalid,
  output logic                          s1_bready,

  output logic [ADDR_WIDTH-1:0]         s1_araddr,
  output logic                          s1_arvalid,
  input  logic                          s1_arready,

  input  logic [DATA_WIDTH-1:0]         s1_rdata,
  input  logic [1:0]                    s1_rresp,
  input  logic                          s1_rvalid,
  output logic                          s1_rready
);

  logic m0_addr_slave0_w, m0_addr_slave1_w;
  logic m0_addr_slave0_r, m0_addr_slave1_r;
  logic m0_addr_valid_w, m0_addr_valid_r;

  logic m1_addr_slave0_w, m1_addr_slave1_w;
  logic m1_addr_slave0_r, m1_addr_slave1_r;
  logic m1_addr_valid_w, m1_addr_valid_r;

  logic m0_write_active;
  logic m0_read_active;
  logic m0_write_error;
  logic m0_read_error;

  logic m1_write_active;
  logic m1_read_active;
  logic m1_write_error;
  logic m1_read_error;

  logic s0_write_grant_m0;
  logic s0_write_grant_m1;
  logic s0_read_grant_m0;
  logic s0_read_grant_m1;
  logic s0_write_owner;
  logic s0_read_owner;

  logic s1_write_grant_m0;
  logic s1_write_grant_m1;
  logic s1_read_grant_m0;
  logic s1_read_grant_m1;
  logic s1_write_owner;
  logic s1_read_owner;

  always_comb begin
    m0_addr_slave0_w = (m0_awaddr[ADDR_WIDTH-1:8] == 8'h00);
    m0_addr_slave1_w = (m0_awaddr[ADDR_WIDTH-1:8] == 8'h01);
    m0_addr_valid_w = m0_addr_slave0_w || m0_addr_slave1_w;

    m0_addr_slave0_r = (m0_araddr[ADDR_WIDTH-1:8] == 8'h00);
    m0_addr_slave1_r = (m0_araddr[ADDR_WIDTH-1:8] == 8'h01);
    m0_addr_valid_r = m0_addr_slave0_r || m0_addr_slave1_r;

    m1_addr_slave0_w = (m1_awaddr[ADDR_WIDTH-1:8] == 8'h00);
    m1_addr_slave1_w = (m1_awaddr[ADDR_WIDTH-1:8] == 8'h01);
    m1_addr_valid_w = m1_addr_slave0_w || m1_addr_slave1_w;

    m1_addr_slave0_r = (m1_araddr[ADDR_WIDTH-1:8] == 8'h00);
    m1_addr_slave1_r = (m1_araddr[ADDR_WIDTH-1:8] == 8'h01);
    m1_addr_valid_r = m1_addr_slave0_r || m1_addr_slave1_r;
  end

  always_comb begin
    s0_write_grant_m0 = 1'b0;
    s0_write_grant_m1 = 1'b0;

    if (s0_write_owner == 1'b0) begin
      if (m0_write_active && m0_addr_slave0_w) begin
        s0_write_grant_m0 = 1'b1;
        s0_write_grant_m1 = 1'b0;
      end else if (m1_write_active && m1_addr_slave0_w) begin
        s0_write_grant_m0 = 1'b0;
        s0_write_grant_m1 = 1'b1;
      end
    end else begin
      if (s0_write_owner == 1'b0) begin
        s0_write_grant_m0 = 1'b1;
      end else begin
        s0_write_grant_m1 = 1'b1;
      end
    end

    s0_read_grant_m0 = 1'b0;
    s0_read_grant_m1 = 1'b0;

    if (s0_read_owner == 1'b0) begin
      if (m0_read_active && m0_addr_slave0_r) begin
        s0_read_grant_m0 = 1'b1;
        s0_read_grant_m1 = 1'b0;
      end else if (m1_read_active && m1_addr_slave0_r) begin
        s0_read_grant_m0 = 1'b0;
        s0_read_grant_m1 = 1'b1;
      end
    end else begin
      if (s0_read_owner == 1'b0) begin
        s0_read_grant_m0 = 1'b1;
      end else begin
        s0_read_grant_m1 = 1'b1;
      end
    end

    s1_write_grant_m0 = 1'b0;
    s1_write_grant_m1 = 1'b0;

    if (s1_write_owner == 1'b0) begin
      if (m0_write_active && m0_addr_slave1_w) begin
        s1_write_grant_m0 = 1'b1;
        s1_write_grant_m1 = 1'b0;
      end else if (m1_write_active && m1_addr_slave1_w) begin
        s1_write_grant_m0 = 1'b0;
        s1_write_grant_m1 = 1'b1;
      end
    end else begin
      if (s1_write_owner == 1'b0) begin
        s1_write_grant_m0 = 1'b1;
      end else begin
        s1_write_grant_m1 = 1'b1;
      end
    end

    s1_read_grant_m0 = 1'b0;
    s1_read_grant_m1 = 1'b0;

    if (s1_read_owner == 1'b0) begin
      if (m0_read_active && m0_addr_slave1_r) begin
        s1_read_grant_m0 = 1'b1;
        s1_read_grant_m1 = 1'b0;
      end else if (m1_read_active && m1_addr_slave1_r) begin
        s1_read_grant_m0 = 1'b0;
        s1_read_grant_m1 = 1'b1;
      end
    end else begin
      if (s1_read_owner == 1'b0) begin
        s1_read_grant_m0 = 1'b1;
      end else begin
        s1_read_grant_m1 = 1'b1;
      end
    end
  end

  always_comb begin
    s0_awaddr = '0;
    s0_awvalid = 1'b0;

    if (s0_write_grant_m0) begin
      s0_awaddr = m0_awaddr;
      s0_awvalid = m0_awvalid;
    end else if (s0_write_grant_m1) begin
      s0_awaddr = m1_awaddr;
      s0_awvalid = m1_awvalid;
    end

    s0_wdata = '0;
    s0_wstrb = '0;
    s0_wvalid = 1'b0;

    if (s0_write_grant_m0) begin
      s0_wdata = m0_wdata;
      s0_wstrb = m0_wstrb;
      s0_wvalid = m0_wvalid;
    end else if (s0_write_grant_m1) begin
      s0_wdata = m1_wdata;
      s0_wstrb = m1_wstrb;
      s0_wvalid = m1_wvalid;
    end

    s0_araddr = '0;
    s0_arvalid = 1'b0;

    if (s0_read_grant_m0) begin
      s0_araddr = m0_araddr;
      s0_arvalid = m0_arvalid;
    end else if (s0_read_grant_m1) begin
      s0_araddr = m1_araddr;
      s0_arvalid = m1_arvalid;
    end
  end

  always_comb begin
    s1_awaddr = '0;
    s1_awvalid = 1'b0;

    if (s1_write_grant_m0) begin
      s1_awaddr = m0_awaddr;
      s1_awvalid = m0_awvalid;
    end else if (s1_write_grant_m1) begin
      s1_awaddr = m1_awaddr;
      s1_awvalid = m1_awvalid;
    end

    s1_wdata = '0;
    s1_wstrb = '0;
    s1_wvalid = 1'b0;

    if (s1_write_grant_m0) begin
      s1_wdata = m0_wdata;
      s1_wstrb = m0_wstrb;
      s1_wvalid = m0_wvalid;
    end else if (s1_write_grant_m1) begin
      s1_wdata = m1_wdata;
      s1_wstrb = m1_wstrb;
      s1_wvalid = m1_wvalid;
    end

    s1_araddr = '0;
    s1_arvalid = 1'b0;

    if (s1_read_grant_m0) begin
      s1_araddr = m0_araddr;
      s1_arvalid = m0_arvalid;
    end else if (s1_read_grant_m1) begin
      s1_araddr = m1_araddr;
      s1_arvalid = m1_arvalid;
    end
  end

  always_comb begin
    m0_bresp = 2'b00;
    m0_bvalid = 1'b0;
    m0_rdata = '0;
    m0_rresp = 2'b00;
    m0_rvalid = 1'b0;

    m1_bresp = 2'b00;
    m1_bvalid = 1'b0;
    m1_rdata = '0;
    m1_rresp = 2'b00;
    m1_rvalid = 1'b0;

    s0_bready = 1'b0;
    s0_rready = 1'b0;

    if (s0_write_grant_m0) begin
      m0_bresp = s0_bresp;
      m0_bvalid = s0_bvalid;
      s0_bready = m0_bready;
    end else if (s0_write_grant_m1) begin
      m1_bresp = s0_bresp;
      m1_bvalid = s0_bvalid;
      s0_bready = m1_bready;
    end

    if (s0_read_grant_m0) begin
      m0_rdata = s0_rdata;
      m0_rresp = s0_rresp;
      m0_rvalid = s0_rvalid;
      s0_rready = m0_rready;
    end else if (s0_read_grant_m1) begin
      m1_rdata = s0_rdata;
      m1_rresp = s0_rresp;
      m1_rvalid = s0_rvalid;
      s0_rready = m1_rready;
    end
  end

  always_comb begin
    s1_bready = 1'b0;
    s1_rready = 1'b0;

    if (s1_write_grant_m0 && !(s0_write_grant_m0 && s0_bvalid)) begin
      m0_bresp = s1_bresp;
      m0_bvalid = s1_bvalid;
      s1_bready = m0_bready;
    end else if (s1_write_grant_m1 && !(s0_write_grant_m1 && s0_bvalid)) begin
      m1_bresp = s1_bresp;
      m1_bvalid = s1_bvalid;
      s1_bready = m1_bready;
    end

    if (s1_read_grant_m0 && !(s0_read_grant_m0 && s0_rvalid)) begin
      m0_rdata = s1_rdata;
      m0_rresp = s1_rresp;
      m0_rvalid = s1_rvalid;
      s1_rready = m0_rready;
    end else if (s1_read_grant_m1 && !(s0_read_grant_m1 && s0_rvalid)) begin
      m1_rdata = s1_rdata;
      m1_rresp = s1_rresp;
      m1_rvalid = s1_rvalid;
      s1_rready = m1_rready;
    end
  end

  always_comb begin
    if (m0_write_active) begin
      if (m0_addr_slave0_w && s0_write_grant_m0)
        m0_awready = s0_awready;
      else if (m0_addr_slave1_w && s1_write_grant_m0)
        m0_awready = s1_awready;
      else
        m0_awready = 1'b0;
    end else begin
      m0_awready = 1'b1;
    end

    if (m0_write_active) begin
      if (m0_addr_slave0_w && s0_write_grant_m0)
        m0_wready = s0_wready;
      else if (m0_addr_slave1_w && s1_write_grant_m0)
        m0_wready = s1_wready;
      else
        m0_wready = 1'b0;
    end else begin
      m0_wready = 1'b0;
    end

    if (m0_read_active) begin
      if (m0_addr_slave0_r && s0_read_grant_m0)
        m0_arready = s0_arready;
      else if (m0_addr_slave1_r && s1_read_grant_m0)
        m0_arready = s1_arready;
      else
        m0_arready = 1'b0;
    end else begin
      m0_arready = 1'b1;
    end

    if (m1_write_active) begin
      if (m1_addr_slave0_w && s0_write_grant_m1)
        m1_awready = s0_awready;
      else if (m1_addr_slave1_w && s1_write_grant_m1)
        m1_awready = s1_awready;
      else
        m1_awready = 1'b0;
    end else begin
      m1_awready = 1'b1;
    end

    if (m1_write_active) begin
      if (m1_addr_slave0_w && s0_write_grant_m1)
        m1_wready = s0_wready;
      else if (m1_addr_slave1_w && s1_write_grant_m1)
        m1_wready = s1_wready;
      else
        m1_wready = 1'b0;
    end else begin
      m1_wready = 1'b0;
    end

    if (m1_read_active) begin
      if (m1_addr_slave0_r && s0_read_grant_m1)
        m1_arready = s0_arready;
      else if (m1_addr_slave1_r && s1_read_grant_m1)
        m1_arready = s1_arready;
      else
        m1_arready = 1'b0;
    end else begin
      m1_arready = 1'b1;
    end
  end

  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      m0_write_active <= 1'b0;
      m0_read_active <= 1'b0;
      m0_write_error <= 1'b0;
      m0_read_error <= 1'b0;

      m1_write_active <= 1'b0;
      m1_read_active <= 1'b0;
      m1_write_error <= 1'b0;
      m1_read_error <= 1'b0;

      s0_write_owner <= 1'b0;
      s0_read_owner <= 1'b0;
      s1_write_owner <= 1'b0;
      s1_read_owner <= 1'b0;
    end else begin
      if (!m0_write_active) begin
        if (m0_awvalid && m0_awready) begin
          m0_write_active <= 1'b1;
          if (!m0_addr_valid_w)
            m0_write_error <= 1'b1;
          else
            m0_write_error <= 1'b0;
        end
      end else begin
        if (m0_bvalid && m0_bready) begin
          m0_write_active <= 1'b0;
          m0_write_error <= 1'b0;
        end
      end

      if (!m0_read_active) begin
        if (m0_arvalid && m0_arready) begin
          m0_read_active <= 1'b1;
          if (!m0_addr_valid_r)
            m0_read_error <= 1'b1;
          else
            m0_read_error <= 1'b0;
        end
      end else begin
        if (m0_rvalid && m0_rready) begin
          m0_read_active <= 1'b0;
          m0_read_error <= 1'b0;
        end
      end

      if (!m1_write_active) begin
        if (m1_awvalid && m1_awready) begin
          m1_write_active <= 1'b1;
          if (!m1_addr_valid_w)
            m1_write_error <= 1'b1;
          else
            m1_write_error <= 1'b0;
        end
      end else begin
        if (m1_bvalid && m1_bready) begin
          m1_write_active <= 1'b0;
          m1_write_error <= 1'b0;
        end
      end

      if (!m1_read_active) begin
        if (m1_arvalid && m1_arready) begin
          m1_read_active <= 1'b1;
          if (!m1_addr_valid_r)
            m1_read_error <= 1'b1;
          else
            m1_read_error <= 1'b0;
        end
      end else begin
        if (m1_rvalid && m1_rready) begin
          m1_read_active <= 1'b0;
          m1_read_error <= 1'b0;
        end
      end

      if (s0_write_grant_m0 && m0_awvalid && s0_awready)
        s0_write_owner <= 1'b0;
      else if (s0_write_grant_m1 && m1_awvalid && s0_awready)
        s0_write_owner <= 1'b1;

      if (s0_read_grant_m0 && m0_arvalid && s0_arready)
        s0_read_owner <= 1'b0;
      else if (s0_read_grant_m1 && m1_arvalid && s0_arready)
        s0_read_owner <= 1'b1;

      if (s1_write_grant_m0 && m0_awvalid && s1_awready)
        s1_write_owner <= 1'b0;
      else if (s1_write_grant_m1 && m1_awvalid && s1_awready)
        s1_write_owner <= 1'b1;

      if (s1_read_grant_m0 && m0_arvalid && s1_arready)
        s1_read_owner <= 1'b0;
      else if (s1_read_grant_m1 && m1_arvalid && s1_arready)
        s1_read_owner <= 1'b1;
    end
  end

endmodule