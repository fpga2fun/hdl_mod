class Agent;

 mailbox #(Transaction) gen2agt, agt2drv;
 Transaction tr;

 function new(input mailbox #(Transaction) gen2agt, agt2drv);
 this.gen2agt = gen2agt;
 this.agt2drv = agt2drv;
 endfunction

 task run();
 forever begin
 gen2agt.get(tr); // 从上游模块中获取事务
 ... // 进行一些处理
 agt2drv.put(tr); // 把事务发送给下游模块
 end
 endtask

 task wrap_up(); // 暂时为空
 endtask
 
endclass