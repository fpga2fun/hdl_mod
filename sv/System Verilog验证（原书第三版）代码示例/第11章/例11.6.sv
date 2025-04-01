//-------------------------------------------------------------
// 构造 environment 实例
function Environment::new(input vUtopiaRx Rx[], input vUtopiaTx Tx[], input int numRx, numTx,
                          input vCPU_T mif);
  this.Rx = new[Rx.size()];
  foreach (Rx[i]) this.Rx[i] = Rx[i];
  this.Tx = new[Tx.size()];
  foreach (Tx[i]) this.Tx[i] = Tx[i];
  this.numRx = numRx;
  this.numTx = numTx;
  this.mif = mif;
  cfg = new(NumRx, NumTx);

  if ($test$plusargs("ntb_random_seed")) begin
    int seed;
    $value$plusargs("ntb_random_seed = %d", seed);
    $display("Simulation run with random seed = %0d", seed);
  end else $display("Simulation run with default random seed");
endfunction : new

//-------------------------------------------------------------
// 随机化配置描述符
function void Environment::gen_cfg();
  `SV_RAND_CHECK(cfg.randomize());
  cfg.display();
endfunction : gen_cfg
//-------------------------------------------------------------
// 为本次测试建立 environment 对象
// 注意需要为每个通道建立对象，即使通道不使用也要建立对象
// 这样可以避免空句柄错误
function void Environment::build();
  cpu = new(mif, cfg);
  gen = new[numRx];
  drv = new[numRx];
  gen2drv = new[numRx];
  drv2gen = new[numRx];
  scb = new(cfg);
  cov = new();

  // 建立发生器
  foreach (gen[i]) begin
    gen2drv[i] = new();
    gen[i] = new(gen2drv[i], drv2gen[i], cfg.cells_per_chan[i], i);
    drv[i] = new(gen2drv[i], drv2gen[i], Rx[i], i);
  end

  // 建立监测器
  mon = new[numTx];
  foreach (mon[i]) mon[i] = new(Tx[i], i);

  // 通过回调函数连接记分牌到驱动器和监视器
  begin
    Scb_Driver_cbs  sdc = new(scb);
    Scb_Monitor_cbs smc = new(scb);
    foreach (drv[i]) drv[i].cbsq.push_back(sdc);
    foreach (mon[i]) mon[i].cbsq.push_back(smc);
  end

  // 通过回调函数连接覆盖率程序到监视器
  begin
    Cov_Monitor_cbs smc = new(cov);
    foreach (mon[i]) mon[i].cbsq.push_back(smc);
  end
endfunction : build

//-------------------------------------------------------------
// 启动事务：发生器、驱动器、监视器
// 不会启动没有使用的通道
task Environment::run();
  int num_gen_running;

  //CPU 接口必须最先初始化
  cpu.run();
  num_gen_running = numRx;

  // 为每个 RX 接收通道启动发生器和驱动器
  foreach (gen[i]) begin
    int j = i;  // 在派生的线程里，自动变量保持了索引值
    fork
      begin
        if (cfg.in_use_Rx[j]) gen[j].run();  // 等待发生器结束
        num_gen_running--;  // 减少驱动器的个数
      end
      if (cfg.in_use_Rx[j]) drv[j].run();
    join_none
  end

  // 为每个 Tx 输出通道启动监视器
  foreach (mon[i]) begin
    int j = i;  // 在派生的线程里，自动变量保持了索引值
    fork
      mon[j].run();
    join_none
  end
  // 等待所有发生器结束或超时
  fork : timeout_block
    wait (num_gen_running == 0);
    begin
      repeat (1_000_000) @(Rx[0].cbr);
      $display("@%0t: %m ERROR: Generator timeout ", $time);
      cfg.nErrors++;
    end
  join_any
  disable timeout_block;

  // 等待数据送到监视器和记分牌
  repeat (1_000) @(Rx[0].cbr);
endtask : run

//-------------------------------------------------------------
// 运行结束后的清除 / 报告工作
function void Environment::wrap_up();
  $display("@%0t: End of sim, %0d errors, %0d warnings", $time, cfg.nErrors, cfg.nWarnings);
  scb.wrap_up();
endfunction : wrap_up
