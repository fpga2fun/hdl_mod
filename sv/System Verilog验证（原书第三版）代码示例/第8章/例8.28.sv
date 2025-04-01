class Driver_cbs_drop extends Driver_cbs;
  virtual task pre_tx(ref Transaction tr, ref bit drop);
    // 每 100 个事务中随机丢弃 1 个
    drop = ($urandom_range(0, 99) == 0);
  endtask
endclass

program automatic test;
  Environment env;
  initial begin
    env = new();
    env.gen_cfg();
    env.build();

    begin  // 创建错误注入的回调任务
      Driver_cbs_drop dcd = new();
      env.drv.cbs.push_back(dcd);  // 放入驱动器队列
    end

    env.run();
    env.wrap_up();
  end

endprogram
