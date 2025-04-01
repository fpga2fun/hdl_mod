class Transaction;
  static Config cfg;
  static int count = 0;
  int id;

  // 显示静态变量的静态方法
  static function void display_statics();
    if (cfg == null) $display("ERROR: configuration not set");
    else $display("Transaction cfg.num_trans = %0d, count = %0d", cfg.num_trans, count);
  endfunction
endclass

Config cfg;
initial begin
  cfg = new(.num_trans(42));  // 通过参数名称传递
  Transaction::cfg = cfg;
  Transaction::display_statics();  // 调用静态方法
end
