class Transactor;
  Transaction tr;
  mailbox #(Transaction) mbx;
  covergroup CovDst5;
    coverpoint tr.dst;
  endgroup

  function new(input mailbox#(Transaction) mbx);
    CovDst5  = new();  // 实例化覆盖组
    this.mbx = mbx;
  endfunction

  task run();
    forever begin
      mbx.get(tr);  // 获取下一个事务
      @ifc.cb;
      ifc.cb.dst  <= tr.dst;  // 发送到待测设计中
      ifc.cb.data <= tr.data;
      CovDst5.sample();  // 收集覆盖率
    end
  endtask

endclass
