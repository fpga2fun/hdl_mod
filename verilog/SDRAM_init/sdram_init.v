//----------------------------------------------------------------------------------------------------
//--SDRAM初始化模块
//----------------------------------------------------------------------------------------------------

//------------<模块及端口声明>------------------------------------------------------------------------
module	sdram_init(
	input				init_clk		,	//时钟信号，100M
	input				init_rst_n		,	//复位信号，低电平有效
	
	output	reg	[12:0]	init_addr		,	//13位SDRAM地址
	output	reg	[3:0]	init_cmd		,	//4位SDRAM命令，组成{CS#,RAS#,CAS#,WE#}
	output	reg	[1:0]	init_bank		,	//2位BANK地址，共4个BANK
	output	reg			init_end			//初始化完成信号，初始化完成后拉高
);
//------------<参数定义>----------------------------------------------------------------------------------
//计数器最大值、刷新次数定义
localparam	T_WAIT = 15'd10_000	,			//100M时钟频率10ns，共计100us
			AR_MAX = 4'd3		;			//自动刷新次数2次
//等待时间参数定义	
localparam	TRP  = 3'd2			,			//发送预充电指令后进行下一个操作需要等待的时间
			TRFC = 3'd8			,			//发送自动刷新指令后进行下一个操作需要等待的时间
			TMRD = 3'd3			;			//发送设置模式寄存器指令后进行下一个操作需要等待的时间
//命令指令参数				
localparam 	PRECHARGE = 4'b0010 , 			//预充电指令
			AT_REF    = 4'b0001 , 			//自动刷新指令
			NOP       = 4'b0111 , 			//空操作指令
			MREG_SET  = 4'b0000 ; 			//模式寄存器设置指令
			
//状态机状态编码，用格雷码编码，也可以使用独热码（但是资源消耗多些）
localparam	INIT_WAIT = 3'b000,				//延时等待状态
			INIT_PRE  = 3'b001,				//预充电状态
			INIT_TRP  = 3'b011,				//预充电等待状态
			INIT_AR   = 3'b010,				//自动刷新状态
			INIT_TRFC = 3'b110,             //自动刷新等待状态
			INIT_MRS  = 3'b111,             //模式寄存器设置状态
			INIT_TMRD = 3'b101,             //模式寄存器设置等待状态
			INIT_END  = 3'b100;             //初始化完成状态
//------------<reg定义>----------------------------------------------------------------------------------											
reg	[14:0]	cnt_wait		;				//100us延时等待状态
reg	[2:0]	state_cur		;				//三段式状态机现态
reg	[2:0]	state_next		;				//三段式状态机次态
reg	[3:0]	cnt_ar			;				//自动刷新计数器,记录刷新次数
reg	[3:0]	cnt_fsm			;				//状态机计数器，用于计数各个状态以实现状态跳转
reg			cnt_fsm_reset	;				//状态机计数器复位信号，高电平有效

//------------<wire定义>----------------------------------------------------------------------------------		
wire		wait_end_flag	;				//上电等待时间结束标志
wire		trp_end_flag	;				//预充电等待时间结束标志
wire		trfc_end_flag	;				//自动刷新等待时间结束标志
wire		tmrd_end_flag	;				//模式寄存器配置等待时间结束标志

//=========================================================================================================
//===========================<main  code>==================================================================
//=========================================================================================================

//因为状态跳转是时序逻辑，所以在前一个周期拉高时间等待参数的标志信号，用来进行状态跳转
assign		wait_end_flag = (cnt_wait == T_WAIT - 'd1)? 1'b1 : 1'b0;
assign		trp_end_flag = ((state_cur == INIT_TRP) && (cnt_fsm == TRP - 1'b1))? 1'b1 : 1'b0;
assign		trfc_end_flag = ((state_cur == INIT_TRFC) && (cnt_fsm == TRFC - 1'b1))? 1'b1 : 1'b0;
assign		tmrd_end_flag = ((state_cur == INIT_TMRD) && (cnt_fsm == TMRD - 1'b1))? 1'b1 : 1'b0;

//初始化结束信号，只有在处于结束状态时拉高，其他时间一律保持低电平
always@(posedge init_clk or negedge init_rst_n)begin
	if(!init_rst_n)
		init_end <= 1'b0;
	else if(state_cur == INIT_END)
		init_end <= 1'b1;
	else
		init_end <= 1'b0;
end

//自动刷新计数器，每进一次状态（INIT_AR，自动刷新指令）则+1，
//这里没必要清零了，因为跳转到8后就不会累加了，而且在初始状态保持0
always@(posedge init_clk or negedge init_rst_n)begin
	if(!init_rst_n)
		cnt_ar <= 4'd0;
	else if(state_cur == INIT_WAIT)
		cnt_ar <= 4'd0;
	else if(state_cur == INIT_AR)
		cnt_ar <= cnt_ar + 1'd1;
	else
		cnt_ar <= cnt_ar;
end

//200us计数器，计数到最大值后，计数器一直保持不变
always@(posedge init_clk or negedge init_rst_n)begin
	if(!init_rst_n)
		cnt_wait <= 15'd0;
	else if(cnt_wait == T_WAIT)
		cnt_wait <= cnt_wait;
	else
		cnt_wait <= cnt_wait + 1'd1;
end

//用于计数各个状态以实现状态跳转,计数复位信号cnt_fsm_reset有效时复位，其他时间累加
always@(posedge init_clk or negedge init_rst_n)begin
	if(!init_rst_n)
		cnt_fsm <= 4'd0;
	else if(cnt_fsm_reset)
		cnt_fsm <= 4'd0;
	else
		cnt_fsm <= cnt_fsm + 1'd1;
end

//工作状态计数器的复位信号
always@(*)begin
	case(state_cur)
		INIT_WAIT:	cnt_fsm_reset = 1'b1; 							//计数器清零
		INIT_TRP: 	cnt_fsm_reset = (trp_end_flag)? 1'b1 : 1'b0;    //完成TRP等待则计数器清零，否则计数 	
		INIT_TRFC: 	cnt_fsm_reset = (trfc_end_flag)? 1'b1 : 1'b0;   //完成TRFC等待则计数器清零，否则计数 
		INIT_TMRD: 	cnt_fsm_reset = (tmrd_end_flag)? 1'b1 : 1'b0; 	//完成TMRD等待则计数器清零，否则计数
		INIT_END:  	cnt_fsm_reset = 1'b1; 							//计数器清零
		default:	cnt_fsm_reset = 1'b0; 							//计数器清零
	endcase
end
//------------<三段式状态机>----------------------------------------------------------------------------------

//--状态机第一段：同步时序描述状态转移
always@(posedge init_clk or negedge init_rst_n)begin
	if(!init_rst_n)
		state_cur <= INIT_WAIT;	
	else
		state_cur <= state_next;
end

//--状态机第二段：组合逻辑判断状态转移条件，描述状态转移规律以及输出
always@(*)begin
	state_next = INIT_WAIT;
	case(state_cur)
		INIT_WAIT:
			if(wait_end_flag)				//200us等待标志拉高则跳转到下一个状态，否则保持在该状态
				state_next = INIT_PRE;
			else
				state_next = INIT_WAIT;		
		INIT_PRE:
			state_next = INIT_TRP;			//跳转到TRP等待状态
		INIT_TRP:
			if(trp_end_flag)				//TRP等待标志拉高则跳转到下一个状态，否则保持在该状态
				state_next = INIT_AR;
			else
				state_next = INIT_TRP;					
		INIT_AR:
			state_next = INIT_TRFC;			//跳转到TRFC等待状态
		INIT_TRFC:
			if(trfc_end_flag)begin			
				if(cnt_ar == AR_MAX)		//TRFC等待标志拉高且自动刷新次数满足时序要求则跳转到下一个状态	
					state_next = INIT_MRS;
				else 						//自动刷新次数要求不达标，继续刷新	
					state_next = INIT_AR;
			end
			else
				state_next = INIT_TRFC;	
		INIT_MRS:
			state_next = INIT_TMRD;			//跳转到INIT_TMRD等待状态
		INIT_TMRD:
			if(tmrd_end_flag)				//INIT_TMRD等待标志拉高且自动刷新次数满足时序要求则跳转到下一个状态
				state_next = INIT_END;
			else	
				state_next = INIT_TMRD;		
		INIT_END:
				state_next = INIT_END;		//一直维持改状态
		default:state_next = INIT_WAIT;		//默认在初始状态
	endcase
end

//--状态机第三段：时序逻辑描述输出
always@(posedge init_clk or negedge init_rst_n)begin
	if(!init_rst_n)begin					//复位输出NOP指令，地址、BANK地址不关心，全拉高就行	
        init_cmd <= NOP;		
	    init_bank	<= 2'b11;
		init_addr <= 13'h1fff;		
	end
	else 	
		case(state_cur)
			INIT_WAIT:begin					//输出NOP指令，地址、BANK地址不关心，全拉高就行	
				init_cmd <= NOP;		
				init_bank	<= 2'b11;
				init_addr <= 13'h1fff;								
			end
			INIT_PRE:begin
				init_cmd <= PRECHARGE;		//输出预充电指令，A10拉高选中所有BANK、BANK地址不关心	
				init_bank	<= 2'b11;
				init_addr <= 13'h1fff;								
			end			
			INIT_TRP:begin
				init_cmd <= NOP;			//输出NOP指令，地址、BANK地址不关心，全拉高就行	
				init_bank	<= 2'b11;
				init_addr <= 13'h1fff;								
			end 
			INIT_AR:begin
				init_cmd <= AT_REF;			//输出自动刷新指令，地址、BANK地址不关心，全拉高就行	
				init_bank	<= 2'b11;
				init_addr <= 13'h1fff;								
			end 
			INIT_TRFC:begin
				init_cmd <= NOP;			//输出NOP指令，地址、BANK地址不关心，全拉高就行
				init_bank	<= 2'b11;
				init_addr <= 13'h1fff;								
			end 
			INIT_MRS:begin
				init_cmd <= MREG_SET;		//输出模式寄存器配置指令，A0~A12地址进行模式配置、BANK地址全拉低
				init_bank	<= 2'b00;
				init_addr <= 
				{
					3'b000	,				//A12-A10:预留
					1'b0	, 				//A9=0:读写方式,0:突发读&突发写,1:突发读&单写
					2'b00	, 				//{A8,A7}=00:标准模式,默认
					3'b011	,				//{A6,A5,A4}=011:CAS 潜伏期,010:2,011:3,其他:保留
					1'b0	, 				//A3=0:突发传输方式,0:顺序,1:隔行
					3'b111 					//{A2,A1,A0}=111:突发长度,000:单字节,001:2 字节
				};								
			end 
			INIT_TMRD:begin					//输出NOP指令，地址、BANK地址不关心，全拉高就行
				init_cmd <= NOP;		
				init_bank	<= 2'b11;
				init_addr <= 13'h1fff;
			end
		    INIT_END:begin
				init_cmd <= NOP;			//输出NOP指令，地址、BANK地址不关心，全拉高就行
				init_bank	<= 2'b11;
				init_addr <= 13'h1fff;
			end 
			default:begin					//默认状态输出NOP指令，地址、BANK地址不关心，全拉高就行
				init_cmd <= NOP;		
				init_bank	<= 2'b11;
				init_addr <= 13'h1fff;
			end
		endcase
end

endmodule