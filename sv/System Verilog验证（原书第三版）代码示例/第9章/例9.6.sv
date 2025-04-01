program automatic test;
  Environment env;

  initial begin
    Driver_cbs_coverage dcc;

    env = new();
    env.gen_cfg();
    env.build();

    // 创建并登记覆盖率回调函数
    dcc = new();
    env.drv.cbs.push_back(dcc);  // 放进驱动器的队列中

    env.run();
    env.wrap_up();
  end

endprogram
