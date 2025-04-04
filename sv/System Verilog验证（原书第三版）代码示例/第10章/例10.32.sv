interface simple_if (
    input logic clk
);
  logic addr;
  logic data;
  logic start = 0;
  bus_cmd_e cmd;
  modport TARGET(
      input addr, cmd, data,
      import task targetRcv(output bus_cmd_e c, logic [7:0] a, d)
  );
  modport INITIATOR(
      output addr, cmd, data,
      import task initiatorSend(input bus_cmd_e c, logic [7:0] a, d)
  );

  // 串行发送
  task initiatorSend(input bus_cmd_e c, logic [7:0] a, d);
    @(posedge clk);
    start <= 1;
    cmd   <= c;
    foreach (a[i]) begin
      addr <= a[i];
      data <= d[i];
      @(posedge clk);
      start <= 0;
    end
    cmd <= IDLE;
  endtask

  // 串行接收
  task targetRcv(output bus_cmd_e c, logic [7:0] a, d);
    @(posedge start);
    c = cmd;
    foreach (a[i]) begin
      @(posedge clk);
      a[i] = addr;
      d[i] = data;
    end
  endtask

endinterface : simple_if
