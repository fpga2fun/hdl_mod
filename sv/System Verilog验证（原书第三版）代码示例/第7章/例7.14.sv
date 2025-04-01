task run_threads();
 ... // 创建一些事务
 fork
 check_trans(tr1); // 产生第一个线程
 check_trans(tr2); // 产生第二个线程
 check_trans(tr3); // 产生第三个线程
 join_none
 ... // 完成其他工作
 // 在这里等待上述线程结束
 wait fork;
endtask