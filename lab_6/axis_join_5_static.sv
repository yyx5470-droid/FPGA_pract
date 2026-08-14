module axis_join_5_static #(
  parameter TDATA_WIDTH = 32
)
(
  input  logic                   s0_tvalid,
  output logic                   s0_tready,
  input  logic [TDATA_WIDTH-1:0] s0_tdata,

  input  logic                   s1_tvalid,
  output logic                   s1_tready,
  input  logic [TDATA_WIDTH-1:0] s1_tdata,

  input  logic                   s2_tvalid,
  output logic                   s2_tready,
  input  logic [TDATA_WIDTH-1:0] s2_tdata,

  input  logic                   s3_tvalid,
  output logic                   s3_tready,
  input  logic [TDATA_WIDTH-1:0] s3_tdata,

  input  logic                   s4_tvalid,
  output logic                   s4_tready,
  input  logic [TDATA_WIDTH-1:0] s4_tdata,

  output logic                   m_tvalid,
  input  logic                   m_tready,
  output logic [TDATA_WIDTH-1:0] m_tdata,
  output logic [2:0]             m_tuser
);

  logic [4:0] req;
  logic [4:0] grant;

  assign req = {s4_tvalid, s3_tvalid, s2_tvalid, s1_tvalid, s0_tvalid};

  always_comb begin
    casez (req[4:0])
      5'b????1 : grant = 5'b00001;
      5'b???10 : grant = 5'b00010;
      5'b??100 : grant = 5'b00100;
      5'b?1000 : grant = 5'b01000;
      5'b10000 : grant = 5'b10000;
      5'b00000 : grant = 5'b00000;
    endcase
  end

  assign m_tvalid = |grant;

  always_comb begin
    case (grant)
      5'b00001: m_tdata = s0_tdata;
      5'b00010: m_tdata = s1_tdata;
      5'b00100: m_tdata = s2_tdata;
      5'b01000: m_tdata = s3_tdata;
      5'b10000: m_tdata = s4_tdata;
      default:  m_tdata = s0_tdata;
    endcase
  end

  always_comb begin
    case (grant)
      5'b00001: m_tuser = 3'd0;
      5'b00010: m_tuser = 3'd1;
      5'b00100: m_tuser = 3'd2;
      5'b01000: m_tuser = 3'd3;
      5'b10000: m_tuser = 3'd4;
      default:  m_tuser = 3'd0;
    endcase
  end

  assign s0_tready = m_tready & grant[0];
  assign s1_tready = m_tready & grant[1];
  assign s2_tready = m_tready & grant[2];
  assign s3_tready = m_tready & grant[3];
  assign s4_tready = m_tready & grant[4];

endmodule