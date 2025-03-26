Transaction t1, t2;  // 声明两个句柄
t1 = new();  // 为第一个 Transaction 对象分配地址
t2 = t1;  //t1 和 t2 都指向该对象
t1 = new();  // 为第二个 Transaction 对象分配地址
