covergroup CovDst8 with function sample (bit [2:0] dst, bit hs);
  coverpoint dst;
  coverpoint hs;  // 高速模式
endgroup

class Transactor;
  CovDst8 condst;
  task run();
    forever begin
      mbx.get(tr);  // 获取下一个事务
      ifc.cb.dst  <= tr.dst;  // 发送到待测设计中
      ifc.cb.data <= tr.data;
      covdst.sample(tr.dst, high_speed);  // 收集覆盖率
    end
  endtask
endclass
