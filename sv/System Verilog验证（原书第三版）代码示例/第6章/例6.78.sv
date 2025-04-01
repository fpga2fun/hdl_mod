program automatic test;

  Environment env;

  initial begin
    env = new();  // 创建环境
    env.gen_cfg();  // 建立随机配置
    env.build();  // 建立测试平台的环境
    env.run();  // 运行测试
    env.wrap_up();  // 整理并产生报告
  end
endprogram
