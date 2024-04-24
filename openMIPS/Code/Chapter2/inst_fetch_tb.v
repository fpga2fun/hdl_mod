
module inst_fetch_tb;

  reg     CLOCK_50;
  reg     rst;
  wire[31:0]    inst;
  
       
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
      
  initial begin
    rst = 1'b1;
    #195 rst= 1'b0;
    #1000 $stop(2);
  end

//  initial begin $readmemh ( "rom.data", inst_fetch0.rom0.rom ); end  
  integer idx;
  initial begin
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars;    //tb模块名称
     for (idx = 0; idx < 15; idx = idx + 1) $dumpvars(0, inst_fetch0.rom0.rom[idx]);  
   end   
   
  inst_fetch inst_fetch0(
		.clk(CLOCK_50),
		.rst(rst),
		.inst_o(inst)	
	);

endmodule