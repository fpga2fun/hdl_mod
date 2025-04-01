class Transaction;
rand bit [3:0] src,dst;
endclass

class Transaction_seq;
 rand Transaction items[10]; // 事务句柄数组

 
 function new(); // 构造序列 items
 foreach (items[i])
 items[i] = new();
 endfunction // new

 constraint c_ascend // 每一个 dst 地址都比前一个大
 { foreach (items[i])
 if (i > 0)
 items[i].dst > items[i-1].dst;
 }
endclass // Transaction_seq;

initial begin
 seq = new(); // 构造序列
 `SV_RAND_CHECK(seq.randomize()); // 随机化
 foreach (seq.items[i])
 $display("item[%0d] = %0d", i, seq.items[i].dst);
End