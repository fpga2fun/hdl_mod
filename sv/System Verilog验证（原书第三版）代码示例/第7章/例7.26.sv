Program automatic test;
class Generator;
 event done;
 function new (input event done); // 从测试平台传来事件
 this.done = done;
 endfunction

 task run();
 fork
 begin
 ... // 创建事务
 -> done; // 告知测试程序任务已完成
 end
 join_none
 endtask
endclass

 event gen_done;
 Generator gen;
 
 initial begin
 gen = new(gen_done); // 测试程序实例化
 gen.run(); // 运行事务处理器
 wait(gen_done.triggered); // 等待任务结束
 end
endprogram