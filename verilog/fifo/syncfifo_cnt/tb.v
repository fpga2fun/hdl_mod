`timescale 1ns/1ns	//时间单位/精度
 
//------------<模块及端口声明>----------------------------------------
module tb_sync_fifo_cnt();
 
parameter   DATA_WIDTH = 8  ;       //FIFO位宽
parameter   DATA_DEPTH = 8 ;         //FIFO深度
 
reg										clk		;
reg										rst_n	;
reg	[DATA_WIDTH-1:0]				data_in	;
reg										rd_en	;
reg										wr_en	;
						
wire	[DATA_WIDTH-1:0]				data_out;	
wire										empty	;	
wire										full	;
wire	[$clog2(DATA_DEPTH) : 0]	fifo_cnt;
 
 
//------------<例化被测试模块>----------------------------------------
sync_fifo_cnt
#(
	.DATA_WIDTH  (DATA_WIDTH),			//FIFO位宽
   .DATA_DEPTH  (DATA_DEPTH)			//FIFO深度
)
sync_fifo_cnt_inst(
	.clk      (clk		),
	.rst_n    (rst_n		),
	.data_in  (data_in	),
	.rd_en    (rd_en		),
	.wr_en    (wr_en		),
                 
	.data_out (data_out	),	
	.empty    (empty		),	
	.full     (full		),
	.fifo_cnt (fifo_cnt	)			
);
 
//------------<设置初始测试条件>----------------------------------------
initial begin
	clk                 <= 1'b0;                   //初始时钟为0
	rst_n               <= 1'b0;                //初始复位
	data_in             <= 1'd0;      
	wr_en               <= 1'b0;    
	rd_en               <= 1'b0;
	#10;
	rst_n 				  <= 1'b1;
//重复8次写操作，让FIFO写满 	
	repeat(8) begin		
		@(negedge clk)begin		        
			wr_en         <= 1'b1;    
			data_in       <= $random;        //生成8位随机数
		end
	end
	#60;
//重复8次读操作，让FIFO读空	
	repeat(8) begin
		@(negedge clk)begin		
			wr_en         <= 1'b0;
			rd_en         <= 1'd1;
		end
	end
	#60;
//重复4次写操作，写入4个随机数据	
	repeat(4) begin
		@(negedge clk)begin		
			wr_en         <= 1'b1;
			data_in       <= $random;  //生成8位随机数
			rd_en         <= 1'b0;
		end
	end
//持续同时对FIFO读写，写入数据为随机数据	
	forever begin
		@(negedge clk)begin		
			wr_en         <= 1'b1;
			data_in       <= $random;  //生成8位随机数
			rd_en         <= 1'b1;
		end
	end
end
 
//------------<设置时钟>----------------------------------------------
always #10 clk         = ~clk;         //系统时钟周期20ns
 initial begin
    #15_000;
        $finish;
end

 `ifdef FSDB
		initial begin
					$fsdbDumpfile("tb.vcd");
					$fsdbDumpvars;
					$fsdbDumpMDA();
				end
`else
integer idx;
	initial begin
    $dumpfile("wave.vcd");
    $dumpvars;	// tb的模块名
	
	for (idx = 0; idx < 8; idx = idx + 1)
    $dumpvars(0,tb_sync_fifo_cnt.sync_fifo_cnt_inst.fifo_buffer[idx]);
	end

`endif
endmodule