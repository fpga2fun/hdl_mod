class Environment;

 EthCfg cfg;
 EthGen gen[4];
 EthMii drv[4];

 function new();
 cfg = new(); // 创建 cfg
 endfunction

 // 使用随机配置建立环境
 function void build();
 foreach (gen[i]) begin
 gen[i] = new();
 drv[i] = new();
 if (cfg.is_100[i])
 drv[i].set_speed(100);
 end
 endfunction

 function void gen_cfg();
 `SV_RAND_CHECK(cfg.randomize()); // 随机化 cfg
 endfunction

 task run();
 foreach (gen[i])
 if (cfg.in_use[i]) begin
 // 仅启动使用中的测试平台的事务处理器
 gen[i].run();
 ...
 end
 endtask
 
 task wrap_up();
 // 暂时还没有使用
 endtask
endclass : Environment