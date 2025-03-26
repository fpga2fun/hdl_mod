program automatic test;

  Environment env;
  initial begin
    env = new();  // 创建 environment 对象
    env.build();  // 创建测试平台对象
    env.run();  // 运行测试
    env.wrap_up();  // 清理
  end
endprogram
