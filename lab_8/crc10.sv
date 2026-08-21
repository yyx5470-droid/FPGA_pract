module crc10
(
  input  logic        clk_i,
  input  logic        rstn_i,
  input  logic [7:0]  din_i,
  input  logic        data_valid_i,
  input  logic        crc_rd,
  output logic [9:0]  crc_o,
  output logic [1:0]  state_o
);

  localparam IDLE = 2'b00;
  localparam BUSY = 2'b01;
  localparam READ = 2'b10;

  logic [1:0] state_ff;
  logic [7:0] data_current_ff;
  logic [3:0] crc_counter_ff;
  logic [9:0] crc_ff;

  always_ff @(posedge clk_i)
  begin
    if (!rstn_i) begin
      state_ff         <= IDLE;
      data_current_ff  <= 8'b0;
      crc_ff           <= 10'b0;
      crc_counter_ff   <= 4'd0;
    end
    else begin
      case (state_ff)
        IDLE:
          begin
            crc_counter_ff <= 4'b0;
            if (data_valid_i)
            begin
              state_ff        <= BUSY;
              data_current_ff <= din_i;
            end
            else if (crc_rd)
              state_ff <= READ;
          end
        BUSY:
          begin
            crc_ff[9] <=  crc_ff[0]^data_current_ff[0];
            crc_ff[8] <= (crc_ff[0]^data_current_ff[0])^crc_ff[9];
            crc_ff[7] <=  crc_ff[8];
            crc_ff[6] <=  crc_ff[7];
            crc_ff[5] <=  crc_ff[6];
            crc_ff[4] <= (crc_ff[0]^data_current_ff[0])^crc_ff[5];
            crc_ff[3] <= (crc_ff[0]^data_current_ff[0])^crc_ff[4];
            crc_ff[2] <=  crc_ff[3];
            crc_ff[1] <=  crc_ff[2];
            crc_ff[0] <= (crc_ff[0]^data_current_ff[0])^crc_ff[1];

            data_current_ff <= {1'b0,data_current_ff[7:1]};
            crc_counter_ff  <= crc_counter_ff + 1'b1;

            if(crc_counter_ff == 4'b0111)
              state_ff <= IDLE;
          end
        READ:
          begin
            crc_ff   <= 10'b0;
            state_ff <= IDLE;
          end
      endcase
    end
  end

  assign crc_o   = crc_ff;
  assign state_o = state_ff;

endmodule