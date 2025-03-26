program initialization;  // 有漏洞的版本

  task check_bus();
    repeat (5) @(posedge clock);
    if (bus_cmd == READ) begin
      // 何时对 local_addr 赋初值？
      logic [7:0] local_addr = addr << 2;  // 有漏洞
      $display("Local Addr = %h", local_addr);
    end
  endtask

endprogram
