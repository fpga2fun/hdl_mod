class Driver_cbs_scoreboard extends Driver_cbs;
  Scoreboard scb;

  virtual task pre_tx(ref Transaction tr, ref bit drop);
    // 将事务放入记分板
    scb.save_expected(tr);
  endtask

  function new(input Scoreboard scb);
    this.scb = scb;
  endfunction
endclass

program automatic test;
  Environment env;

  initial begin
    env = new();
    env.gen_cfg();
    env.build();

    begin  // 创建计分板回调
      Driver_cbs_scoreboard dcs = new(env.scb);
      env.drv.cbs.push_back(dcs);  // 放入驱动器队列
    end

    env.run();
    env.wrap_up();
  end

endprogram
