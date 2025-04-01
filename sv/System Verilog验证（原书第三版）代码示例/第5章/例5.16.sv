class Transaction;
  static Config cfg;  // 使用静态存储的句柄
endclass

initial begin
  Transaction::cfg = new(.num_trans(42));
end
