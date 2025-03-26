task write(reg [15:0] addr, reg [31:0] data);
  // 驱动控制总线
  @(posedge clk) PAddr <= addr;
  PWData <= data;
  PWrite <= 1'b1;
  PSel   <= 1'b1;

  // 使 PEnable 翻转
  @(posedge clk) PEnable <= 1'b1;
  @(posedge clk) PEnable <= 1'b0;
endtask
