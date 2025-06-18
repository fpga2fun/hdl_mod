// ****************************************************************************************************************
// ** 作者 ： 孤独的单刀                                                   			
// ** 邮箱 ： zachary_wu93@163.com
// ** 博客 ： https://blog.csdn.net/wuzhikaidetb 
// ** 日期 ： 2024/04/24
// ** 模块 ： 多bits信号的CDC同步模块	
// ** 功能 ： 1、通过附带指示信号的方法，将多bits信号完成跨时钟域同步
//			  2、适用从慢时钟域同步到快时钟域，也适用从快时钟域同步到慢时钟域
//			  3、同步级数参数化可配置
//			  4、为了优化逻辑，这里假设要同步的信号已经是时序逻辑信号
// ****************************************************************************************************************	
 
module sync_handshake #(
	parameter						DATA_WIDTH = 8		,	//要同步的数据的位宽
	parameter						SYNC_STAGE = 2			//同步级数，一般配置为2级即可，若频率较高则可配置为3级
)
(
//源时钟域的信号（即同步前的信号）
	input							clk_source			,	//源时钟（慢时钟）
	input							rst_source			,	//高有效的同步复位
	input							sig_pulse_source	,	//同步前的数据指示信号（脉冲信号）
	input	[DATA_WIDTH - 1:0]		sig_data_source		,	//同步前的多bits数据
 
//目的时钟域的信号（即同步后的信号）		
	input							clk_dest			,	//目的时钟（快时钟）
	input							rst_dest			,	//高有效的同步复位
	output							sync_busy			,	//握手忙信号，高电平表示当前正在进行握手过程，此时不应该再发起一次新的请求
	output	reg	[DATA_WIDTH - 1:0]	sig_data_dest			//同步后的多bits数据		
);
 
//定义reg
reg	[SYNC_STAGE : 0]	sig_pulse_ff			;		//展宽后的信号的同步寄存器，同步级数要加1，因为第1拍是不稳定的，为了提取上升沿只能用第2拍和第3拍
reg	[SYNC_STAGE -1 : 0]	sig_pulse_fback_ff		;		//反馈信号的同步寄存器，同步级级不需要加1
reg						sig_pulse_source_level	;		//打拍后的信号在源时钟域展宽
reg						sig_pulse_dest			;		//同步后的数据指示信号（脉冲信号）
reg	[DATA_WIDTH - 1:0]	sig_data_source_latch	;		//锁存同步前的数据
 
assign sync_busy = sig_pulse_source_level || sig_pulse_fback_ff[SYNC_STAGE -1];	//握手过程
 
//在源时钟域，把脉冲信号信号展宽成电平信号，这样可以保证同步后一定能被采集到
always @(posedge clk_source)begin
	if(rst_source)
		sig_pulse_source_level <= 1'b0;
	else if(sig_pulse_fback_ff[SYNC_STAGE -1])		//握手完成后的反馈信号	
		sig_pulse_source_level <= 1'b0;				//当同步完成后则拉低
	else if(sig_pulse_source)
		sig_pulse_source_level <= 1'b1;				//当脉冲有效则拉高
end
 
//在源时钟域，把数据信号锁存保持住
always @(posedge clk_source)begin
	if(rst_source)
		sig_data_source_latch <= 1'b0;
	else if(sig_pulse_source)						//当数据有效时
		sig_data_source_latch <= sig_data_source;	//把数据锁存住
end
 
//在目的时钟域，把展宽后的信号同步过来，为了提取上升沿需要多同步1级，例如设定SYNC_STAGE为2，则应做3个FF同步
always @(posedge clk_dest)begin
	if(rst_dest)
		sig_pulse_ff <= {(SYNC_STAGE+1){1'b0}};		//这样写不会报警告
	else
        sig_pulse_ff <= {sig_pulse_ff[SYNC_STAGE-1:0],sig_pulse_source_level};	//多级FF同步
end
 
//在目的时钟域，提取取上升沿作为同步后的脉冲信号
always @(posedge clk_dest)begin
	if(rst_dest)
		sig_pulse_dest <= 1'b0;
	else
        sig_pulse_dest <= ~sig_pulse_ff[SYNC_STAGE] && sig_pulse_ff[SYNC_STAGE-1];	//上升沿
end
 
//在目的时钟域，根据同步后的脉冲信号来采集稳定的同步前的数据信号
always @(posedge clk_dest)begin
	if(rst_dest)
		sig_data_dest <= {(DATA_WIDTH){1'b0}};		//这样写不会报警告
	else if(sig_pulse_dest)							//数据有效指示信号同步完成
        sig_data_dest <= sig_data_source_latch;		//采集之前锁存的数据
end
 
//把同步到目的时钟域的展宽信号再反馈回去，这样可以将源时钟域的展宽信号拉低，结束一次握手进程
always @(posedge clk_source)begin
	if(rst_source)
		sig_pulse_fback_ff <= {(SYNC_STAGE){1'b0}};		//这样写不会报警告
	else							
		sig_pulse_fback_ff <= {sig_pulse_fback_ff[SYNC_STAGE-1:0],sig_pulse_ff[SYNC_STAGE-1]};	//多级FF同步
end
 
endmodule