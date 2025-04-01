class Driver;
 mailbox #(Transaction) gen2drv; // 发生器和驱动器间的信箱

 function new(input mailbox #(Transaction) gen2drv);
 this.gen2drv = gen2drv;
 endfunction
 
 virtual task run();
 Transaction tr; // 指向一个 Transaction 对象
 // 或者是由 Transaction 派生得到的类
 forever begin
 gen2drv.get(tr); // 从发生器获得 transaction
 tr.calc_csm(); // 处理 transation
 @ifc.cb;
 ifc.cb.src <= tr.src; // 发送 transaction
 ...
 end
 endtask
endclass