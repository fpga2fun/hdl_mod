class Environment;

  Generator gen;
  Agent agt;
  Driver drv;
  Monitor mon;
  Checker chk;
  Scoreboard scb;
  Config cfg;
  mailbox #(Transaction) gen2agt, agt2drv, mon2chk;

  extern function new();
  extern function void gen_cfg();
  extern function void build();
  extern task run();
  extern task wrap_up();
endclass

function Environment::new();
  cfg = new();
endfunction

function void Environment::gen_cfg();
  `SV_RAND_CHECK(cfg.randomize);
endfunction

function void Environment::build();
  // 初始化信箱
  gen2agt = new();
  agt2drv = new();
  mon2chk = new();

  // 初始化事务处理器
  gen = new(gen2agt);
  agt = new(gen2agt, agt2drv);
  drv = new(agt2drv);
  mon = new(mon2chk);
  chk = new(mon2chk);
  scb = new(cfg);
endfunction

task Environment::run();
  fork
    gen.run(cfg.run_for_n_trans);
    agt.run();
    drv.run();
    mon.run();
    chk.run();
    scb.run(cfg.run_for_n_trans);
  join
endtask

task Environment::wrap_up();
  fork
    gen.wrap_up();
    agt.wrap_up();
    drv.wrap_up();
    mon.wrap_up();
    chk.wrap_up();
    scb.wrap_up();
  join
endtask
