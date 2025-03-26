class Transactor; // 通用类
 Transaction tr;
 
 task run();
 forever begin
 // 从前一个块中获取事务
 ...
 // 做一些处理
 ...
 // 发送到下游块中
 ...
 end
 endtask
endclass