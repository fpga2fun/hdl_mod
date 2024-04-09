//----------------------------------------------------------------------------------------------------
//--SDRAM初始化仿真测试
//----------------------------------------------------------------------------------------------------
`timescale  1ns/1ns		
`define iverilog_sim 
module  tb_sdram_init();

//------------<wire定义>----------------------------------------------------------------------------------
`ifdef iverilog_sim	
reg            clk_50m         ;                       //PLL输出50M时钟
reg            clk_100m        ;                       //PLL输出100M时钟
reg            clk_100m_shift  ;                       //PLL输出100M时钟,相位偏移-90deg
`else 
wire            clk_50m         ;   					//PLL输出50M时钟
wire            clk_100m        ;   					//PLL输出100M时钟
wire            clk_100m_shift  ;   					//PLL输出100M时钟,相位偏移-90deg
`endif
wire            locked          ;   					//PLL时钟锁定信号
wire            rst_n           ;   					//复位信号,低有效
					
wire    [3:0]   init_cmd        ;   					//初始化阶段指令
wire    [1:0]   init_bank       ;   					//初始化阶段L-Bank地址
wire    [12:0]  init_addr       ;   					//初始化阶段地址总线
wire            init_end        ;   					//初始化完成信号

//------------<reg定义>----------------------------------------------------------------------------------		
reg             sys_clk         ;   					//系统时钟
reg             sys_rst_n       ;   					//复位信号
//------------<defparam定义>----------------------------------------------------------------------------------		
//重定义仿真模型中的相关参数
defparam sdram_model_plus_inst.addr_bits = 13;          //地址位宽
defparam sdram_model_plus_inst.data_bits = 16;          //数据位宽
defparam sdram_model_plus_inst.col_bits  = 9;           //列地址位宽
defparam sdram_model_plus_inst.mem_sizes = 2*1024*1024; //L-Bank容量

//------------<设置初始测试条件>----------------------------------------
initial
  begin
    sys_clk     =   1'b1  ;
    sys_rst_n   <=  1'b0  ;
    clk_50m     = 1'b1;
    clk_100m    = 1'b1;
    clk_100m_shift = 1'b0;
    #200
    sys_rst_n   <=  1'b1  ;
  end
//时钟信号
always  #10 sys_clk = ~sys_clk;

//rst_n:复位信号
assign  rst_n = sys_rst_n & locked;

//------------<例化被测试模块>----------------------------------------

//PLL模块
`ifdef iverilog_sim
always  #10 clk_50m = ~clk_50m;
always  #5  clk_100m = ~clk_100m;
always  #5  clk_100m_shift = ~clk_100m_shift;
`else
clk_gen clk_gen_inst (
    .inclk0     (sys_clk        ),
    .areset     (~sys_rst_n     ),
    .c0         (clk_50m        ),
    .c1         (clk_100m       ),
    .c2         (clk_100m_shift ),
    .locked     (locked         )
);
`endif
//sdram初始化模块
sdram_init  sdram_init_inst(

    .init_clk   (clk_100m   ),
    .init_rst_n (rst_n      ),

    .init_cmd   (init_cmd   ),
    .init_bank	(init_bank	),
    .init_addr  (init_addr  ),
    .init_end   (init_end   )

);

//sdram模型模块
sdram_model_plus    sdram_model_plus_inst(
    .Dq     (               ),
    .Addr   (init_addr      ),
    .Ba     (init_bank		),
    .Clk    (clk_100m_shift ),
    .Cke    (1'b1           ),			//时钟使能信号一直拉高
    .Cs_n   (init_cmd[3]    ),
    .Ras_n  (init_cmd[2]    ),
    .Cas_n  (init_cmd[1]    ),
    .We_n   (init_cmd[0]    ),
    .Dqm    (4'b0           ),
    .Debug  (1'b1           )			//使能在MODLESIM窗口打印输出信息

);
//------------------------------------------------
//--    状态机名称查看器
//------------------------------------------------
reg [79:0]	name_state_cur;			//每字符8位宽，这里取最多10个字符80位宽

always @(*) begin
    case(sdram_init_inst.state_cur)
        3'b000:		name_state_cur = "INIT_WAIT ";
        3'b001:		name_state_cur = "INIT_PRE  ";
        3'b011:		name_state_cur = "INIT_TRP  ";
        3'b010:		name_state_cur = "INIT_AR   "; 
		3'b110:		name_state_cur = "INIT_TRFC "; 
		3'b111:		name_state_cur = "INIT_MRS  "; 
		3'b101:		name_state_cur = "INIT_TMRD "; 
		3'b100:		name_state_cur = "INIT_END  "; 
        default:	name_state_cur = "INIT_WAIT";
    endcase
end

initial begin
   forever begin
      #100;
      if ($time >= 101350)  $finish ;
   end
end

 initial begin
 $dumpfile("wave.vcd");
 $dumpvars(0,tb_sdram_init);  // 0表示自顶向下的所有信号均要dump，tb的模块名
 end

//------------------------------------------------

endmodule