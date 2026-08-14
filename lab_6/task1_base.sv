`timescale 1ns / 1ps

module task1_base
(
  input  logic        clk_i,
  input  logic        rstn_i,

  input  logic [15:0] data_a_i,
  input  logic        valid_a_i,
  output logic        ready_a_o,

  input  logic [15:0] data_b_i,
  input  logic        valid_b_i,
  output logic        ready_b_o,

  input  logic [15:0] data_c_i,
  input  logic        valid_c_i,
  output logic        ready_c_o,

  output logic [32:0] data_y_o,
  output logic        valid_y_o,
  input  logic        ready_y_i
);

  logic [32:0] m_data_ff;
  logic        m_valid_ff;
  
  logic        all_valids;
  logic        s_ready;

  assign all_valids = valid_a_i & valid_b_i & valid_c_i;
  
  assign s_ready = ~m_valid_ff | ready_y_i;

  assign ready_a_o = valid_b_i & valid_c_i & s_ready;
  assign ready_b_o = valid_a_i & valid_c_i & s_ready;
  assign ready_c_o = valid_a_i & valid_b_i & s_ready;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i)
      m_valid_ff <= '0;
    else if (s_ready)
      m_valid_ff <= all_valids;
  end

  always_ff @(posedge clk_i) begin
    if (s_ready & all_valids)
      m_data_ff <= $signed(data_a_i) * $signed(data_a_i) + $signed(data_c_i) * $signed(data_b_i);
  end

  assign valid_y_o = m_valid_ff;
  assign data_y_o  = m_data_ff;

endmodule
