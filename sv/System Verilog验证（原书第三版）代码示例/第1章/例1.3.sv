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
  // 此处省略如例 1.2 给出的任务函数

  initial begin
    reset();  // 设备复位
    write(16'h50, 32'h50);  // 把数据写入到存储器中

    // 校验结果
    if (top.mem.memory[16'h50] == 32'h50) $display("Success");
    else $display("Error, wrong value in memory");
    $finish;
  end
endmodule
