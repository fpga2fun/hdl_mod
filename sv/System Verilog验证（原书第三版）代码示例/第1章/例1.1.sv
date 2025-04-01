module test (
    PAddr,
    PWrite,
    PSel,
    PWData,
    PEnable,
    Rst,
    clk
);
  // 此处省略端口声明

  initial begin
    // 驱动复位

    Rst <= 0;
    #100 Rst <= 1;

    // 驱动控制总线
    @(posedge clk) PAddr <= 16'h50;
    PWData <= 32'h50;
    PWrite <= 1'b1;
    PSel   <= 1'b1;

    // 使 PEnable 翻转
    @(posedge clk) PEnable <= 1'b1;
    @(posedge clk) PEnable <= 1'b0;

    // 校验结果
    if (top.mem.memory[16'h50] == 32'h50) $display("Success");
    else $display("Error, wrong value in memory");
    $finish;
  end
endmodule
