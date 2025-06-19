module iddr_ctrl(
   input       clk      ,//系统时钟信号；
   input       rst      ,//系统复位信号，高电平有效；

   input       clk_en   ,//时钟使能信号；
   input       din      ,//输入数据；
   output      dout1    ,//输出数据
   output      dout2    
); 
   reg         clk_en_r ;
   //(* IOB = "TRUE" *)reg clk_en_r ;//将clk_en_r放在ILOGICE中；

   //将clk_en打拍，用于验证IOB原语是否有效；
   always@(posedge clk)begin
      clk_en_r <= clk_en;
   end

   //例化IDDR原语
   IDDR #(
      .DDR_CLK_EDGE  ("SAME_EDGE_PIPELINED"  ),// "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED" 
      .INIT_Q1       (1'b0                   ),// Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2       (1'b0                   ),// Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE        ("SYNC"                 ) // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
   IDDR_inst (
      .Q1   (dout1   ),// 1-bit output for positive edge of clock
      .Q2   (dout2   ),// 1-bit output for negative edge of clock
      .C    (clk     ),// 1-bit clock input
      .CE   (clk_en_r),// 1-bit clock enable input
      .D    (din     ),// 1-bit DDR data input
      .R    (rst     ),// 1-bit reset
      .S    (1'b0    ) // 1-bit set
   );

endmodule