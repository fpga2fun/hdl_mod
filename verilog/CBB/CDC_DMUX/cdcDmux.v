
`timescale 1ns/1ns
 
module  CBB_DMUX #(
// ---- parameter define
parameter P_TIMING_MODE = "DATA_VALID-ALIGN",//"DATA_VALID-1" or "DATA_VALID-ALIGN"
parameter P_SYNC_STAGE  = 2,
parameter P_DATA_WIDTH  = 16
)(
// ---- port define 
input 							i_clk_src,
input 							i_rstn_src,
input 							i_valid_src,//must be register output(source clk)
input 	[P_DATA_WIDTH-1:0] 		i_data_src, //must be register output(source clk)
 
input 							i_clk_dst,
input 							i_rstn_dst,
output 							o_valid_dst,
output  [P_DATA_WIDTH-1:0]		o_data_dst
);
// ---- parameter define
localparam LP_EXTEN_EN			= (P_TIMING_MODE == "DATA_VALID-1") ? "ENABLE" : "DISABLE";  
localparam LP_EXTEN_MULT 		= 3;	     
localparam LP_SYNC_STAGE 		= P_SYNC_STAGE;	     
localparam LP_PULSE_WIDTH     	= "CARE-1";  
 
wire 					w_valid_dst;
reg 					r_valid_dst;
reg [P_DATA_WIDTH-1:0] 	r_data_dst;
 
always @(posedge i_clk_dst or negedge i_rstn_dst) begin : proc_valid_sync
	if(~i_rstn_dst) begin
		 r_valid_dst <= 1'b0;
	end else begin
		 r_valid_dst <= w_valid_dst;
	end
end	
 
always @(posedge i_clk_dst or negedge i_rstn_dst) begin : proc_data_sync
	if(~i_rstn_dst) begin
		 r_data_dst <= {(P_DATA_WIDTH){1'b0}};
	end else if(w_valid_dst)begin
		 r_data_dst <= i_data_src;
	end
end	

assign o_valid_dst = r_valid_dst;
assign o_data_dst  = r_data_dst;
 
CBB_PULSE_SYNCHRONIZER #(
		.P_EXTEN_EN   (LP_EXTEN_EN),
		.P_EXTEN_MULT (LP_EXTEN_MULT),
		.P_SYNC_STAGE (LP_SYNC_STAGE),
		.P_PULSE_WIDTH(LP_PULSE_WIDTH)
	) U_CBB_PULSE_SYNCHRONIZER (
		.i_clk_src   (i_clk_src),
		.i_rstn_src  (i_rstn_src),
		.i_pulse_src (i_valid_src),
		.i_clk_dst   (i_clk_dst),
		.i_rstn_dst  (i_rstn_dst),
		.o_pulse_dst (w_valid_dst)
	);
endmodule