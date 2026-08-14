module pipeline (
  input  logic        clk_i,
  input  logic        rstn_i,

  input  logic        s_tvalid,
  output logic        s_tready,
  input  logic [15:0] s_tdata,

  output logic        m_tvalid,
  input  logic        m_tready,
  output logic [31:0] m_tdata
);

  logic [31:0] st1_tdata;
  logic        st1_tvalid;
  logic        st1_tready;

  logic [31:0] st2_tdata;
  logic        st2_tvalid;
  logic        st2_tready;

  logic [31:0] st3_tdata;
  logic        st3_tvalid;
  logic        st3_tready;

  logic [31:0] st4_tdata;
  logic        st4_tvalid;
  logic        st4_tready;

  logic [31:0] previous_value;
  
  assign s_tready = ~st1_tvalid | st1_tready;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      st1_tvalid <= 1'd0;
      st1_tdata  <= 32'd0;
    end
    else if (s_tready) begin

      st1_tvalid <= s_tvalid;

      if (s_tvalid)
        st1_tdata <= {16'd0, s_tdata} - 32'd1;
    end
  end

  assign st1_tready = ~st2_tvalid | st2_tready;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      st2_tvalid <= 1'b0;
      st2_tdata  <= 32'd0;
    end
    else if (st1_tready) begin

      st2_tvalid <= st1_tvalid;

      if (st1_tvalid)
        st2_tdata <= st1_tdata * 32'd3;
    end
  end

  assign st2_tready = ~st3_tvalid | st3_tready;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      st3_tvalid    <= 1'b0;
      st3_tdata     <= 32'd0;
      previous_value <= 32'd0;
    end
    else if (st2_tready) begin

      st3_tvalid <= st2_tvalid;

      if (st2_tvalid) begin
        st3_tdata <= st2_tdata + previous_value;
         previous_value <= st2_tdata;
      end
    end
  end

  assign st3_tready = ~st4_tvalid | st4_tready;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      st4_tvalid <= 1'b0;
      st4_tdata  <= 32'd0;
    end
    else if (st3_tready) begin
   
      st4_tvalid <= st3_tvalid;

      if (st3_tvalid)
        st4_tdata <= st3_tdata % 32'd128;
    end
  end

  assign st4_tready = ~m_tvalid | m_tready;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      m_tvalid <= 1'b0;
      m_tdata  <= 32'd0;
    end
    else if (st4_tready) begin

      m_tvalid <= st4_tvalid;

      if (st4_tvalid)
        m_tdata <= st4_tdata + 32'd10;
    end
  end

endmodule