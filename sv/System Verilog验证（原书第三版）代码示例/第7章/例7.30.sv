program automatic test(bus_ifc.TB bus);
 semaphore sem; // 创建一个旗语
 initial begin
 sem = new(1); // 分配 1 个钥匙
 fork
 sequencer(); // 产生两个总线事务线程
 sequencer(); 
 join
 end

 task sequencer();
 repeat($urandom()%10) // 随机等待 0-9 个周期
 @bus.cb;
 sendTrans(); // 执行事务
 endtask
 
 task sendTrans();
 sem.get(1); // 获取总线钥匙
 @bus.cb; // 把信号驱动到总线上
 bus.cb.addr <= t.addr;
 ...
 sem.put(1); // 处理完成时把钥匙返回
 endtask
endprogram