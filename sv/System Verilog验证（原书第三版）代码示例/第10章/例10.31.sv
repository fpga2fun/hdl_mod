interface simple_if (
    input logic clk
);
  logic [7:0] addr;
  logic [7:0] data;
  bus_cmd_e cmd;
  modport TARGET(
      input addr, cmd, data,
      import task targetRcv(output bus_cmd_e c, logic [7:0] a, d)
  );
  modport INITIATOR(
      output addr, cmd, data,
      import task initiatorSend(input bus_cmd_e c, logic [7:0] a, d)
  );

  // 并行发送
  task initiatorSend(input bus_cmd_e c, logic [7:0] a, d);
    @(posedge clk);
    cmd  <= c;
    addr <= a;
    data <= d;
  endtask

  // 并行接收
  task targetRcv(output bus_cmd_e c, logic [7:0] a, d);
    @(posedge clk);
    a = addr;  // 使用非阻塞赋值立即获取总线数值
    d = data;  // 以免造成冲突
    c = cmd;
  endtask
endinterface : simple_if
