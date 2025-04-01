// 将包传送到一个 32 位总线上
task transmit(input Transaction tr);
 tr.data[0] = ~tr.data[0]; // 改变第一个字
 CBbus.rx_data <= tr.data[0];
 ...
endtask

Transaction tr;
initial begin
 tr = new(); // 为对象分配空间
 tr.addr = 42; // 初始化数值
 transmit(tr); // 将对象传递给任务
end