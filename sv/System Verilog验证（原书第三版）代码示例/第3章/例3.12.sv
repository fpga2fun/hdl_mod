task automatic bus_read(input logic [31:0] addr, ref logic [31:0] data);

  // 请求总线并驱动地址
  bus_request <= 1'b1;
  @(posedge bus_grant) bus_addr = addr;

  // 等待来自存储器的数据
  @(posedge bus_enable) data = bus_data;

  // 释放总线并等待许可
  bus_request <= 1'b0;
  @(negedge bus_grant);
endtask

logic [31:0] addr, data;

initial
fork
  bus_read(addr, data);
  begin : thread2
    @data;  // 在数据变化时触发
    $display("Read %h from bus", data);
  end
join
