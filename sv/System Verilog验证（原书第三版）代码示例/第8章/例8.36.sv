class GenBase
endclass

class Generator #(type T = BaseTr) extends GenBase;
 // 见例 8.34 的发生器类
endclass

 GenBase gen_queue[$];
 Generator #(Transaction) gen_good;
 Generator #(BadTr) gen_bad;
 
 initial begin
 gen_good = new(); // 构造正确的发生器
 gen_queue.push_back(gen_good); // 保存到队列
 gen_bad = new(); // 构造错误的发生器
 gen_queue.push_back(gen_bad); // 保存到同一个队列
 end