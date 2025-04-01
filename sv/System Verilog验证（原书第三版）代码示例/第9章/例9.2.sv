program automatic test (
    busifc.TB ifc
);

  class Transaction;
    rand bit [31:0] data;
    rand bit [ 2:0] dst;  // 8 种 dst 端口（port）数据
  endclass

  Transaction tr;  // 待采样的事务

  covergroup CovDst2;
    coverpoint tr.dst;  // 测量覆盖率
  endgroup

  initial begin
    CovDst2 ck;
    ck = new();  // 实例化组
    repeat (32) begin  // 运行几个周期
      @ifc.cb;  // 等待一个周期
      tr = new();
      `SV_RAND_CHECK(tr.randomize);  // 创建一个事务
      ifc.cb.dst  <= tr.dst;  // 并发送到接口上
      ifc.cb.data <= tr.data;
      ck.sample();  // 收集覆盖率
    end
  end
endprogram
