
`timescale 1ns/1ns

// `define CLK_CASE_FAST_2_LOW
`define CLK_CASE_LOW_2_FAST
module  tb();

    parameter P_TIMING_MODE = "DATA_VALID-ALIGN";//"DATA_VALID-1" or "DATA_VALID-ALIGN"
    parameter P_SYNC_STAGE  = 2;
    parameter P_DATA_WIDTH  = 16;

    // ---- port define
    reg 							i_clk_src;
    reg 							i_rstn_src;
    reg 							i_valid_src;//must be register output(source clk)
    reg 	[P_DATA_WIDTH-1:0] 		i_data_src; //must be register output(source clk)

    reg 							i_clk_dst;
    reg 							i_rstn_dst;
    wire 							o_valid_dst;
    wire  [P_DATA_WIDTH-1:0]		o_data_dst;

    // 产生时钟
`ifdef CLK_CASE_FAST_2_LOW
    initial
        i_clk_src = 1'b0;
    always #5 i_clk_src = ~i_clk_src;
    initial
        i_clk_dst = 1'b0;
    always #10 i_clk_dst = ~i_clk_dst;
`endif

`ifdef CLK_CASE_LOW_2_FAST
    initial
        i_clk_src = 1'b0;
    always #10 i_clk_src = ~i_clk_src;
    initial
        i_clk_dst = 1'b0;
    always #5 i_clk_dst = ~i_clk_dst;
`endif

integer seed;
initial seed = 32'h1234_5678; // 可选，初始化种子
    //
    initial begin
        i_rstn_src = 1'b0;
        i_rstn_dst = 1'b0;
        i_valid_src = 1'b0;
        i_data_src = {P_DATA_WIDTH{1'b0}};
        #100;
        i_rstn_dst = 1'b1;
        i_rstn_src = 1'b1;
        #50;
        repeat(10) begin
            begin
                if(P_TIMING_MODE == "DATA_VALID-1") begin
                    @(posedge i_clk_src)
                     i_valid_src <= 1'b1;
                    i_data_src <= $random(seed) % 2**16;
                    @(posedge i_clk_src)
                     i_valid_src <= 1'b0;
                    @(negedge o_valid_dst);
                end
                else begin
                    @(posedge i_clk_src)
                     i_valid_src <= 1'b1;
                    i_data_src <= $random(seed) % 2**16;
                    repeat(20) @(posedge i_clk_dst);
                    @(posedge i_clk_src)
                     i_valid_src <= 1'b0;
                end
            end
            #500;
        end

        $finish;
    end


    CBB_DMUX #(
                 .P_TIMING_MODE(P_TIMING_MODE),
                 .P_SYNC_STAGE(P_SYNC_STAGE),
                 .P_DATA_WIDTH(P_DATA_WIDTH)
             ) U_CBB_DMUX (
                 .i_clk_src   (i_clk_src),
                 .i_rstn_src  (i_rstn_src),
                 .i_valid_src (i_valid_src),
                 .i_data_src  (i_data_src),
                 .i_clk_dst   (i_clk_dst),
                 .i_rstn_dst  (i_rstn_dst),
                 .o_valid_dst (o_valid_dst),
                 .o_data_dst  (o_data_dst)
             );
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,tb);
        #5000 $finish;
    end
endmodule
