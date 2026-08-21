module wrapper_dual_crc
(
  input  logic        p_clk_i,
  input  logic        p_rstn_i,
  input  logic [31:0] p_dat_i,
  output logic [31:0] p_dat_o,
  input  logic        p_sel_i,
  input  logic        p_enable_i,
  input  logic        p_we_i,
  input  logic [31:0] p_adr_i,
  output logic        p_ready,
  output logic        p_slverr
);

  logic [7:0]  din_i;
  logic [7:0]  crc8_o;
  logic [9:0]  crc10_o;
  logic [1:0]  crc8_state;
  logic [1:0]  crc10_state;
  logic        crc8_rd;
  logic        crc10_rd;
  logic        crc8_data_valid;
  logic        crc10_data_valid;
  logic        ctrl_reg_ff;

  assign p_slverr = 1'b0;

  crc8 i_crc8
  (
    .clk_i        (p_clk_i),
    .rstn_i       (p_rstn_i),
    .din_i        (din_i),
    .data_valid_i (crc8_data_valid),
    .crc_rd       (crc8_rd),
    .crc_o        (crc8_o),
    .state_o      (crc8_state)
  );

  crc10 i_crc10
  (
    .clk_i        (p_clk_i),
    .rstn_i       (p_rstn_i),
    .din_i        (din_i),
    .data_valid_i (crc10_data_valid),
    .crc_rd       (crc10_rd),
    .crc_o        (crc10_o),
    .state_o      (crc10_state)
  );

  logic cs_1_ff;
  logic cs_2_ff;

  always_ff @(posedge p_clk_i)
  begin
    cs_1_ff <= p_enable_i & p_sel_i;
    cs_2_ff <= cs_1_ff;
  end

  logic cs;
  assign cs = cs_1_ff & (~cs_2_ff);

  logic cs_ack1_ff;
  logic cs_ack2_ff;

  always_ff @(posedge p_clk_i)
  begin
    cs_ack1_ff <= cs_2_ff;
    cs_ack2_ff <= cs_ack1_ff;
  end

  logic p_ready_ff;

  always_ff @(posedge p_clk_i)
  begin
    p_ready_ff <= (cs_ack1_ff & (~cs_ack2_ff));
  end

  assign p_ready = p_ready_ff;

  always_ff @(posedge p_clk_i)
  begin
    if (!p_rstn_i)
      ctrl_reg_ff <= 1'b0;
    else if (cs & p_we_i & (p_adr_i[3:0] == 4'd12))
      ctrl_reg_ff <= p_dat_i[0];
  end

  always_comb
  begin
    p_dat_o = '0;
    if (cs & (~p_we_i) & (p_adr_i[3:0] == 4'd4))
    begin
      if (ctrl_reg_ff == 1'b0)
        p_dat_o = {24'd0, crc8_o};
      else
        p_dat_o = {22'd0, crc10_o};
    end
    else if (cs & (~p_we_i) & (p_adr_i[3:0] == 4'd8))
    begin
      if (ctrl_reg_ff == 1'b0)
        p_dat_o = {30'd0, crc8_state};
      else
        p_dat_o = {30'd0, crc10_state};
    end
    else if (cs & (~p_we_i) & (p_adr_i[3:0] == 4'd12))
    begin
      p_dat_o = {31'd0, ctrl_reg_ff};
    end
  end

  assign din_i = (cs & p_we_i & (p_adr_i[3:0] == 4'd0)) ? p_dat_i[7:0] : 8'd0;

  assign crc8_data_valid  = (cs & p_we_i & (p_adr_i[3:0] == 4'd0) & (ctrl_reg_ff == 1'b0));
  assign crc10_data_valid = (cs & p_we_i & (p_adr_i[3:0] == 4'd0) & (ctrl_reg_ff == 1'b1));

  assign crc8_rd  = (cs & ~p_we_i & (p_adr_i[3:0] == 4'd4) & (ctrl_reg_ff == 1'b0));
  assign crc10_rd = (cs & ~p_we_i & (p_adr_i[3:0] == 4'd4) & (ctrl_reg_ff == 1'b1));

endmodule