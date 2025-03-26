program automatic test;

  Environment env;
  initial begin
    env = new();
    env.build();  // 创建发生器等

    begin
      BadTr bad = new();  // 以 bad 对象取代蓝图
      env.gen.blueprint = bad;
    end

    env.run();  // 运行带 BadTr 的测试
    env.wrap_up();  // 清理内存
  end
endprogram
