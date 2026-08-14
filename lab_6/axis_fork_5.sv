module axis_fork_5 #(
  parameter TDATA_WIDTH = 32
)
(
  input  logic                   s_tvalid,
  output logic                   s_tready,
  input  logic [TDATA_WIDTH-1:0] s_tdata,
  input  logic [2:0]             s_tdest,

  output logic                   m0_tvalid,
  input  logic                   m0_tready,
  output logic [TDATA_WIDTH-1:0] m0_tdata,
    
  output logic                   m1_tvalid,
  input  logic                   m1_tready,
  output logic [TDATA_WIDTH-1:0] m1_tdata,

  output logic                   m2_tvalid,
  input  logic                   m2_tready,
  output logic [TDATA_WIDTH-1:0] m2_tdata,

  output logic                   m3_tvalid,
  input  logic                   m3_tready,
  output logic [TDATA_WIDTH-1:0] m3_tdata,

  output logic                   m4_tvalid,
  input  logic                   m4_tready,
  output logic [TDATA_WIDTH-1:0] m4_tdata
);

  assign m0_tdata = s_tdata;
  assign m1_tdata = s_tdata;
  assign m2_tdata = s_tdata;
  assign m3_tdata = s_tdata;
  assign m4_tdata = s_tdata;

  assign m0_tvalid = s_tvalid & (s_tdest == 3'd0);
  assign m1_tvalid = s_tvalid & (s_tdest == 3'd1);
  assign m2_tvalid = s_tvalid & (s_tdest == 3'd2);
  assign m3_tvalid = s_tvalid & (s_tdest == 3'd3);
  assign m4_tvalid = s_tvalid & (s_tdest == 3'd4);

  always_comb begin
    case (s_tdest)
      3'd0: s_tready = m0_tready;
      3'd1: s_tready = m1_tready;
      3'd2: s_tready = m2_tready;
      3'd3: s_tready = m3_tready;
      3'd4: s_tready = m4_tready;
      default: s_tready = 1'b0;
    endcase
  end

endmodule