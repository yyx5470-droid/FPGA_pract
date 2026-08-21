module axi_interconnect #(
  parameter int ADDR_WIDTH = 16,
  parameter int DATA_WIDTH = 32
)(
  input  logic                          aclk,
  input  logic                          aresetn,

  input  logic [ADDR_WIDTH-1:0]         m_awaddr,
  input  logic                          m_awvalid,
  output logic                          m_awready,

  input  logic [DATA_WIDTH-1:0]         m_wdata,
  input  logic [DATA_WIDTH/8-1:0]       m_wstrb,
  input  logic                          m_wvalid,
  output logic                          m_wready,

  output logic [1:0]                    m_bresp,
  output logic                          m_bvalid,
  input  logic                          m_bready,

  input  logic [ADDR_WIDTH-1:0]         m_araddr,
  input  logic                          m_arvalid,
  output logic                          m_arready,

  output logic [DATA_WIDTH-1:0]         m_rdata,
  output logic [1:0]                    m_rresp,
  output logic                          m_rvalid,
  input  logic                          m_rready,

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

  logic write_active; 
  logic read_active; 
  logic selected_slave_w;
  logic selected_slave_r;
   
  logic addr_in_slave0_w; 
  logic addr_in_slave1_w;
  logic addr_in_slave0_r;
  logic addr_in_slave1_r;
  logic addr_valid_w;
  logic addr_valid_r;
    
  logic write_error;
  logic read_error;

  always_comb begin
    addr_in_slave0_w = (m_awaddr[ADDR_WIDTH-1:8] == 8'h00);
    addr_in_slave1_w = (m_awaddr[ADDR_WIDTH-1:8] == 8'h01);
    addr_valid_w = addr_in_slave0_w || addr_in_slave1_w;
        
    addr_in_slave0_r = (m_araddr[ADDR_WIDTH-1:8] == 8'h00);
    addr_in_slave1_r = (m_araddr[ADDR_WIDTH-1:8] == 8'h01);
    addr_valid_r = addr_in_slave0_r || addr_in_slave1_r;
  end

  always_comb begin
    s0_awaddr = m_awaddr;
    s0_awvalid = 1'b0;
    s1_awaddr = m_awaddr;
    s1_awvalid = 1'b0;
        
    if (!write_active) begin
      if (addr_in_slave0_w) begin
        s0_awvalid = m_awvalid;
        m_awready = s0_awready;
      end else if (addr_in_slave1_w) begin
        s1_awvalid = m_awvalid;
        m_awready = s1_awready;
      end else begin
        m_awready = 1'b1;
      end
    end else begin
      m_awready = 1'b0;
    end
  end

  always_comb begin
    s0_wdata = m_wdata;
    s0_wstrb = m_wstrb;
    s0_wvalid = 1'b0;
    s1_wdata = m_wdata;
    s1_wstrb = m_wstrb;
    s1_wvalid = 1'b0;
        
    if (write_active) begin
      if (selected_slave_w == 1'b0) begin
        s0_wvalid = m_wvalid;
        m_wready = s0_wready;
      end else begin
        s1_wvalid = m_wvalid;
        m_wready = s1_wready;
      end
    end else begin
      m_wready = 1'b0;
    end
  end

  always_comb begin
    m_bresp = 2'b00;
    m_bvalid = 1'b0;
    s0_bready = 1'b0;
    s1_bready = 1'b0;
        
    if (write_error) begin
      m_bresp = 2'b11;
      m_bvalid = 1'b1;
    end else if (write_active) begin
      if (selected_slave_w == 1'b0) begin
        m_bresp = s0_bresp;
        m_bvalid = s0_bvalid;
        s0_bready = m_bready;
      end else begin
        m_bresp = s1_bresp;
        m_bvalid = s1_bvalid;
        s1_bready = m_bready;
      end
    end
  end

  always_comb begin
    s0_araddr = m_araddr;
    s0_arvalid = 1'b0;
    s1_araddr = m_araddr;
    s1_arvalid = 1'b0;
        
    if (!read_active) begin
      if (addr_in_slave0_r) begin
        s0_arvalid = m_arvalid;
        m_arready = s0_arready;
      end else if (addr_in_slave1_r) begin
        s1_arvalid = m_arvalid;
        m_arready = s1_arready;
      end else begin
        m_arready = 1'b1;
      end
    end else begin
      m_arready = 1'b0;
    end
  end

  always_comb begin
    m_rdata = '0;
    m_rresp = 2'b00;
    m_rvalid = 1'b0;
    s0_rready = 1'b0;
    s1_rready = 1'b0;
        
    if (read_error) begin
      m_rdata = '0;
      m_rresp = 2'b11;
      m_rvalid = 1'b1;
    end else if (read_active) begin
      if (selected_slave_r == 1'b0) begin
        m_rdata = s0_rdata;
        m_rresp = s0_rresp;
        m_rvalid = s0_rvalid;
        s0_rready = m_rready;
      end else begin
        m_rdata = s1_rdata;
        m_rresp = s1_rresp;
        m_rvalid = s1_rvalid;
        s1_rready = m_rready;
      end
    end
  end

  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      write_active <= 1'b0;
      read_active <= 1'b0;
      selected_slave_w <= 1'b0;
      selected_slave_r <= 1'b0;
      write_error <= 1'b0;
      read_error <= 1'b0;
    end else begin
    if (!write_active) begin
      if (m_awvalid && m_awready) begin
        write_active <= 1'b1;
      if (addr_in_slave0_w) begin
        selected_slave_w <= 1'b0;
        write_error <= 1'b0;
      end else if (addr_in_slave1_w) begin
        selected_slave_w <= 1'b1;
        write_error <= 1'b0;
      end else begin
        selected_slave_w <= 1'b0;
        write_error <= 1'b1;
      end
    end
  end else begin
    if (m_bvalid && m_bready) begin
      write_active <= 1'b0;
      write_error <= 1'b0;
    end
  end        
    if (!read_active) begin
      if (m_arvalid && m_arready) begin
        read_active <= 1'b1;
      if (addr_in_slave0_r) begin
        selected_slave_r <= 1'b0;
        read_error <= 1'b0;
      end else if (addr_in_slave1_r) begin
        selected_slave_r <= 1'b1;
        read_error <= 1'b0;
      end else begin
        selected_slave_r <= 1'b0;
        read_error <= 1'b1;
      end
    end
    end else begin
      if (m_rvalid && m_rready) begin
        read_active <= 1'b0;
        read_error <= 1'b0;
      end
      end
    end
  end

endmodule