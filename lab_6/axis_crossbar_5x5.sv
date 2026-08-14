module axis_crossbar_5x5 #(
  parameter TDATA_WIDTH = 32
)
(
  input logic clk,
  input logic rst_n,

  input  logic s0_tvalid, output logic s0_tready, input logic [TDATA_WIDTH-1:0] s0_tdata, input logic [2:0] s0_tdest,
  input  logic s1_tvalid, output logic s1_tready, input logic [TDATA_WIDTH-1:0] s1_tdata, input logic [2:0] s1_tdest,
  input  logic s2_tvalid, output logic s2_tready, input logic [TDATA_WIDTH-1:0] s2_tdata, input logic [2:0] s2_tdest,
  input  logic s3_tvalid, output logic s3_tready, input logic [TDATA_WIDTH-1:0] s3_tdata, input logic [2:0] s3_tdest,
  input  logic s4_tvalid, output logic s4_tready, input logic [TDATA_WIDTH-1:0] s4_tdata, input logic [2:0] s4_tdest,

  output logic m0_tvalid, input logic m0_tready, output logic [TDATA_WIDTH-1:0] m0_tdata, output logic [2:0] m0_tuser,
  output logic m1_tvalid, input logic m1_tready, output logic [TDATA_WIDTH-1:0] m1_tdata, output logic [2:0] m1_tuser,
  output logic m2_tvalid, input logic m2_tready, output logic [TDATA_WIDTH-1:0] m2_tdata, output logic [2:0] m2_tuser,
  output logic m3_tvalid, input logic m3_tready, output logic [TDATA_WIDTH-1:0] m3_tdata, output logic [2:0] m3_tuser,
  output logic m4_tvalid, input logic m4_tready, output logic [TDATA_WIDTH-1:0] m4_tdata, output logic [2:0] m4_tuser
);

  logic f0_j0_v, f0_j1_v, f0_j2_v, f0_j3_v, f0_j4_v;
  logic f0_j0_r, f0_j1_r, f0_j2_r, f0_j3_r, f0_j4_r;
  logic [TDATA_WIDTH-1:0] f0_j0_d, f0_j1_d, f0_j2_d, f0_j3_d, f0_j4_d;

  logic f1_j0_v, f1_j1_v, f1_j2_v, f1_j3_v, f1_j4_v;
  logic f1_j0_r, f1_j1_r, f1_j2_r, f1_j3_r, f1_j4_r;
  logic [TDATA_WIDTH-1:0] f1_j0_d, f1_j1_d, f1_j2_d, f1_j3_d, f1_j4_d;

  logic f2_j0_v, f2_j1_v, f2_j2_v, f2_j3_v, f2_j4_v;
  logic f2_j0_r, f2_j1_r, f2_j2_r, f2_j3_r, f2_j4_r;
  logic [TDATA_WIDTH-1:0] f2_j0_d, f2_j1_d, f2_j2_d, f2_j3_d, f2_j4_d;

  logic f3_j0_v, f3_j1_v, f3_j2_v, f3_j3_v, f3_j4_v;
  logic f3_j0_r, f3_j1_r, f3_j2_r, f3_j3_r, f3_j4_r;
  logic [TDATA_WIDTH-1:0] f3_j0_d, f3_j1_d, f3_j2_d, f3_j3_d, f3_j4_d;

  logic f4_j0_v, f4_j1_v, f4_j2_v, f4_j3_v, f4_j4_v;
  logic f4_j0_r, f4_j1_r, f4_j2_r, f4_j3_r, f4_j4_r;
  logic [TDATA_WIDTH-1:0] f4_j0_d, f4_j1_d, f4_j2_d, f4_j3_d, f4_j4_d;

  axis_fork_5 #(.TDATA_WIDTH(TDATA_WIDTH)) fork_0 (
    .s_tvalid(s0_tvalid), .s_tready(s0_tready), .s_tdata(s0_tdata), .s_tdest(s0_tdest),
    .m0_tvalid(f0_j0_v),  .m0_tready(f0_j0_r),  .m0_tdata(f0_j0_d),
    .m1_tvalid(f0_j1_v),  .m1_tready(f0_j1_r),  .m1_tdata(f0_j1_d),
    .m2_tvalid(f0_j2_v),  .m2_tready(f0_j2_r),  .m2_tdata(f0_j2_d),
    .m3_tvalid(f0_j3_v),  .m3_tready(f0_j3_r),  .m3_tdata(f0_j3_d),
    .m4_tvalid(f0_j4_v),  .m4_tready(f0_j4_r),  .m4_tdata(f0_j4_d)
  );

  axis_fork_5 #(.TDATA_WIDTH(TDATA_WIDTH)) fork_1 (
    .s_tvalid(s1_tvalid), .s_tready(s1_tready), .s_tdata(s1_tdata), .s_tdest(s1_tdest),
    .m0_tvalid(f1_j0_v),  .m0_tready(f1_j0_r),  .m0_tdata(f1_j0_d),
    .m1_tvalid(f1_j1_v),  .m1_tready(f1_j1_r),  .m1_tdata(f1_j1_d),
    .m2_tvalid(f1_j2_v),  .m2_tready(f1_j2_r),  .m2_tdata(f1_j2_d),
    .m3_tvalid(f1_j3_v),  .m3_tready(f1_j3_r),  .m3_tdata(f1_j3_d),
     .m4_tvalid(f1_j4_v),  .m4_tready(f1_j4_r),  .m4_tdata(f1_j4_d)
  );

  axis_fork_5 #(.TDATA_WIDTH(TDATA_WIDTH)) fork_2 (
    .s_tvalid(s2_tvalid), .s_tready(s2_tready), .s_tdata(s2_tdata), .s_tdest(s2_tdest),
    .m0_tvalid(f2_j0_v),  .m0_tready(f2_j0_r),  .m0_tdata(f2_j0_d),
    .m1_tvalid(f2_j1_v),  .m1_tready(f2_j1_r),  .m1_tdata(f2_j1_d),
    .m2_tvalid(f2_j2_v),  .m2_tready(f2_j2_r),  .m2_tdata(f2_j2_d),
    .m3_tvalid(f2_j3_v),  .m3_tready(f2_j3_r),  .m3_tdata(f2_j3_d),
    .m4_tvalid(f2_j4_v),  .m4_tready(f2_j4_r),  .m4_tdata(f2_j4_d)
  );

  axis_fork_5 #(.TDATA_WIDTH(TDATA_WIDTH)) fork_3 (
    .s_tvalid(s3_tvalid), .s_tready(s3_tready), .s_tdata(s3_tdata), .s_tdest(s3_tdest),
    .m0_tvalid(f3_j0_v),  .m0_tready(f3_j0_r),  .m0_tdata(f3_j0_d),
    .m1_tvalid(f3_j1_v),  .m1_tready(f3_j1_r),  .m1_tdata(f3_j1_d),
    .m2_tvalid(f3_j2_v),  .m2_tready(f3_j2_r),  .m2_tdata(f3_j2_d),
    .m3_tvalid(f3_j3_v),  .m3_tready(f3_j3_r),  .m3_tdata(f3_j3_d),
    .m4_tvalid(f3_j4_v),  .m4_tready(f3_j4_r),  .m4_tdata(f3_j4_d)
  );

  axis_fork_5 #(.TDATA_WIDTH(TDATA_WIDTH)) fork_4 (
    .s_tvalid(s4_tvalid), .s_tready(s4_tready), .s_tdata(s4_tdata), .s_tdest(s4_tdest),
    .m0_tvalid(f4_j0_v),  .m0_tready(f4_j0_r),  .m0_tdata(f4_j0_d),
    .m1_tvalid(f4_j1_v),  .m1_tready(f4_j1_r),  .m1_tdata(f4_j1_d),
    .m2_tvalid(f4_j2_v),  .m2_tready(f4_j2_r),  .m2_tdata(f4_j2_d),
    .m3_tvalid(f4_j3_v),  .m3_tready(f4_j3_r),  .m3_tdata(f4_j3_d),
    .m4_tvalid(f4_j4_v),  .m4_tready(f4_j4_r),  .m4_tdata(f4_j4_d)
  );

  axis_join_5_static #(.TDATA_WIDTH(TDATA_WIDTH)) join_0 (
    .s0_tvalid(f0_j0_v),  .s0_tready(f0_j0_r),  .s0_tdata(f0_j0_d),
    .s1_tvalid(f1_j0_v),  .s1_tready(f1_j0_r),  .s1_tdata(f1_j0_d),
    .s2_tvalid(f2_j0_v),  .s2_tready(f2_j0_r),  .s2_tdata(f2_j0_d),
    .s3_tvalid(f3_j0_v),  .s3_tready(f3_j0_r),  .s3_tdata(f3_j0_d),
    .s4_tvalid(f4_j0_v),  .s4_tready(f4_j0_r),  .s4_tdata(f4_j0_d),
    .m_tvalid (m0_tvalid),.m_tready (m0_tready),.m_tdata (m0_tdata), .m_tuser(m0_tuser)
  );

  axis_join_5_static #(.TDATA_WIDTH(TDATA_WIDTH)) join_1 (
    .s0_tvalid(f0_j1_v),  .s0_tready(f0_j1_r),  .s0_tdata(f0_j1_d),
    .s1_tvalid(f1_j1_v),  .s1_tready(f1_j1_r),  .s1_tdata(f1_j1_d),
    .s2_tvalid(f2_j1_v),  .s2_tready(f2_j1_r),  .s2_tdata(f2_j1_d),
    .s3_tvalid(f3_j1_v),  .s3_tready(f3_j1_r),  .s3_tdata(f3_j1_d),
    .s4_tvalid(f4_j1_v),  .s4_tready(f4_j1_r),  .s4_tdata(f4_j1_d),
    .m_tvalid (m1_tvalid),.m_tready (m1_tready),.m_tdata (m1_tdata), .m_tuser(m1_tuser)
  );

  axis_join_5_static #(.TDATA_WIDTH(TDATA_WIDTH)) join_2 (
    .s0_tvalid(f0_j2_v),  .s0_tready(f0_j2_r),  .s0_tdata(f0_j2_d),
    .s1_tvalid(f1_j2_v),  .s1_tready(f1_j2_r),  .s1_tdata(f1_j2_d),
    .s2_tvalid(f2_j2_v),  .s2_tready(f2_j2_r),  .s2_tdata(f2_j2_d),
    .s3_tvalid(f3_j2_v),  .s3_tready(f3_j2_r),  .s3_tdata(f3_j2_d),
    .s4_tvalid(f4_j2_v),  .s4_tready(f4_j2_r),  .s4_tdata(f4_j2_d),
    .m_tvalid (m2_tvalid),.m_tready (m2_tready),.m_tdata (m2_tdata), .m_tuser(m2_tuser)
  );

  axis_join_5_static #(.TDATA_WIDTH(TDATA_WIDTH)) join_3 (
    .s0_tvalid(f0_j3_v),  .s0_tready(f0_j3_r),  .s0_tdata(f0_j3_d),
    .s1_tvalid(f1_j3_v),  .s1_tready(f1_j3_r),  .s1_tdata(f1_j3_d),
    .s2_tvalid(f2_j3_v),  .s2_tready(f2_j3_r),  .s2_tdata(f2_j3_d),
    .s3_tvalid(f3_j3_v),  .s3_tready(f3_j3_r),  .s3_tdata(f3_j3_d),
    .s4_tvalid(f4_j3_v),  .s4_tready(f4_j3_r),  .s4_tdata(f4_j3_d),
    .m_tvalid (m3_tvalid),.m_tready (m3_tready),.m_tdata (m3_tdata), .m_tuser(m3_tuser)
  );
  
  axis_join_5_static #(.TDATA_WIDTH(TDATA_WIDTH)) join_4 (
    .s0_tvalid(f0_j4_v),  .s0_tready(f0_j4_r),  .s0_tdata(f0_j4_d),
    .s1_tvalid(f1_j4_v),  .s1_tready(f1_j4_r),  .s1_tdata(f1_j4_d),
    .s2_tvalid(f2_j4_v),  .s2_tready(f2_j4_r),  .s2_tdata(f2_j4_d),
    .s3_tvalid(f3_j4_v),  .s3_tready(f3_j4_r),  .s3_tdata(f3_j4_d),
    .s4_tvalid(f4_j4_v),  .s4_tready(f4_j4_r),  .s4_tdata(f4_j4_d),
    .m_tvalid (m4_tvalid),.m_tready (m4_tready),.m_tdata (m4_tdata), .m_tuser(m4_tuser)
  );

endmodule