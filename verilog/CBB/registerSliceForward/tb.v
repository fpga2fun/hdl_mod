

`timescale 1ns/1ps

module  tb();
    // ---- parameter define
    parameter P_DATA_WIDTH 		= 32;

    // ---- port define
    reg 						i_clk;
    reg 						i_rstn;

    reg 						slv_i_valid;
    reg [P_DATA_WIDTH-1:0] 		slv_i_data;
    wire 						slv_o_ready;

    wire 						mst_o_valid;
    wire [P_DATA_WIDTH-1:0] 	mst_o_data;
    reg 						mst_i_ready;

    initial
        i_clk = 1'b0;
    always #5 i_clk = ~i_clk;

    integer time_dly1,time_dly2;


    initial begin
        i_rstn = 1'b0;
        mst_i_ready = 1'b0;
        #20;
        i_rstn = 1'b1;
        #20;
        repeat(20) begin
            time_dly1 = $urandom_range(1,10);
            repeat(time_dly1) begin
                @(posedge i_clk);
            end
            @(posedge i_clk)
             mst_i_ready <= 1'b1;

            time_dly1 = $urandom_range(1,10);
            repeat(time_dly1) begin
                @(posedge i_clk);
            end
            @(posedge i_clk)
             mst_i_ready <= 1'b0;
        end
    end

    initial begin
        slv_i_valid = 1'b0;
        slv_i_data  = 0;
        @(posedge i_rstn);
        #20;
        repeat(20) begin
            @(posedge i_clk)
             slv_i_valid <= 1'b1;
            slv_i_data  <= $random;
            while(~slv_o_ready)
                @(posedge i_clk);
            @(posedge i_clk)
             slv_i_valid <= 1'b0;
            slv_i_data  <= 0;

            time_dly2 = $urandom_range(1,10);
            repeat(time_dly2) @(posedge i_clk);
        end
        #100;
        $finish;
    end

    CBB_RS_FORWARD #(
                       .P_DATA_WIDTH(P_DATA_WIDTH)
                   ) U_CBB_RS_FORWARD (
                       .i_clk       (i_clk),
                       .i_rstn      (i_rstn),
                       .slv_i_valid (slv_i_valid),
                       .slv_i_data  (slv_i_data),
                       .slv_o_ready (slv_o_ready),
                       .mst_o_valid (mst_o_valid),
                       .mst_o_data  (mst_o_data),
                       .mst_i_ready (mst_i_ready)
                   );
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,tb);
        #5000 $finish;
    end
endmodule
/* @wavedrom
{
  "signal": [
    {"name": "i_clk", "wave": "p.............."},
    {"name": "i_rstn", "wave": "0.1......23..."},
    {"name": "mst_i_ready", "wave": ".0.1..........."},
    {"name": "slv_i_valid", "wave": ".0.1..........."},
    {"name": "slv_i_data", "wave": ".0.1..........."},
    {"name": "slv_o_ready", "wave": ".0.1..........."},
    {"name": "mst_o_valid", "wave": ".0.1..........."},
    {"name": "mst_o_data", "wave": ".0.1..........."}
  ]
}

*/