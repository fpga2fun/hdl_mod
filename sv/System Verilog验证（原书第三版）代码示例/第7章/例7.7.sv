class Gen_drive;
 // 创建 N 个数据包的事务处理器
 task run(input int n);
 Packet p;

 fork
 repeat (n) begin
 p = new();
 `SV_RAND_CHECK(p.randomize());
 transmit(p);
 end
 join_none // 使用 fork-join_none 以使 run() 不发生阻塞
 endtask
 
 task transmit(input Packet p);
 ...
 endtask
endclass

Gen_drive gen;

initial begin
     gen = new();
 gen.run(10);
 // 启动检验、监测和其他线程
 ...
end
