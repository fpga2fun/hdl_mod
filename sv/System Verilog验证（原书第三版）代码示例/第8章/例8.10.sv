class Nearby extends Transaction;
  constraint c_nearby {dst inside {[src - 100 : src + 100]};}
  // 在这里没有列出 copy 方法的代码
endclass

program automatic test;
  Environment env;
  initial begin
    env = new();
    env.build();  // 创建发生器等

    begin
      Nearby nb = new();  // 创建一个新的蓝图
      env.gen.blueprint = nb;  // 替换蓝图
    end

    env.run();  // 运行带 Nearby 的测试程序
    env.wrap_up();  // 清理内存
  end
endprogram
