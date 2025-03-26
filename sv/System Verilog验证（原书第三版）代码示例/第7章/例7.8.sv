program automatic test (
    bus_ifc.TB bus
);
  // 这里省略描述接口的代码
  task check_trans(input Transaction tr);
    fork
      begin
        wait (bus.cb.data == tr.data);
        $display("@%0t: data match %d", $time, tr.data);
      end
    join_none  // 创建线程，不阻塞
  endtask

  Transaction tr;

  initial begin
    repeat (10) begin
      tr = new();  // 创建一个随机事务
      `SV_RAND_CHECK(tr.randomize());
      transmit(tr);  // 把事务发送到被测设计中
      check_trans(tr);  // 等待被测设计的回复
    end
    #100;  // 等待事务的最终完成
  end
endprogram
