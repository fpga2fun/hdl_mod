 
`timescale 1ns/1ps
 
 `define TC_FAST_2_LOW
//`define TC_LOW_2_FAST
 
module tb ();
// ---- parameter define
//parameter P_EXTEN_EN		= "DISABLE"; //"ENABLE" or "DISABLE"需要进行脉冲展宽时，将使能开关打开；
parameter P_EXTEN_MULT 		= 3;	    //2 or larger 表示脉冲在源时钟域被展宽的倍数，这个倍数需要使用者根据上述1.5或2倍关系折算。
parameter P_SYNC_STAGE 		= 2;	    //2 or larger 表示目的时钟域打拍的级数。
parameter P_PULSE_WIDTH     = "CARE-1"; //"CARE-1" or "NOTCARE" "CARE-1"表示，目的侧时钟域输出的脉冲宽度为1个时钟周期；“NOTCARE”则表示目的侧打拍直接输出，不取边沿
 
// ---- port define 
reg 							i_clk_src;
reg 							i_rstn_src;
reg 							i_pulse_src;//must be register output(source clk)
 
reg  							i_clk_dst;
reg  							i_rstn_dst;
wire 							o_pulse_dst;
 
// 产生时钟
`ifdef TC_FAST_2_LOW
initial i_clk_src = 1'b0;
always #5 i_clk_src = ~i_clk_src;
initial i_clk_dst = 1'b0;
always #10 i_clk_dst = ~i_clk_dst;
parameter P_EXTEN_EN		= "ENABLE";
`endif
 
`ifdef TC_LOW_2_FAST
initial i_clk_src = 1'b0;
always #10 i_clk_src = ~i_clk_src;
initial i_clk_dst = 1'b0;
always #5 i_clk_dst = ~i_clk_dst;
parameter P_EXTEN_EN		= "DISABLE"; //"ENABLE" or "DISABLE"
`endif
 
// 
initial
begin
	i_rstn_src = 1'b0;
	i_rstn_dst = 1'b0;
	i_pulse_src = 1'b0;
	#100;
	i_rstn_dst = 1'b1;
	i_rstn_src = 1'b1;
	#50;
	@(posedge i_clk_src)
	i_pulse_src <= 1'b1;
	@(posedge i_clk_src)
	i_pulse_src <= 1'b0;
 
//	@(negedge o_pulse_dst);
	#200;
	$finish;
end
 
CBB_PULSE_SYNCHRONIZER #(
		.P_EXTEN_EN(P_EXTEN_EN),
		.P_EXTEN_MULT(P_EXTEN_MULT),
		.P_SYNC_STAGE(P_SYNC_STAGE),
		.P_PULSE_WIDTH(P_PULSE_WIDTH)
	) U_CBB_PULSE_SYNCHRONIZER (
		.i_clk_src   (i_clk_src),
		.i_rstn_src  (i_rstn_src),
		.i_pulse_src (i_pulse_src),
		.i_clk_dst   (i_clk_dst),
		.i_rstn_dst  (i_rstn_dst),
		.o_pulse_dst (o_pulse_dst)
	);
 
     initial begin
        $dumpfile("tb.vcd");        
        $dumpvars(0,tb);
        #5000 $finish;
    end
 
endmodule
 
 