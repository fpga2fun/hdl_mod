class EthCfg;
  rand bit [3:0] in_use;  // 测试中使用的端口 :3,2,1,0
  rand bit [47:0] mac_addr[4];  //MAC 地址
  rand bit [3:0] is_100;  //100MB 模式，端口：3,2,1,0
  rand uint run_for_n_frames;  // 测试中的帧数

  // 在 unicast 模式设置某些地址位
  constraint local_unicast {foreach (mac_addr[i]) mac_addr[i][41:40] == 2'b00;}

  constraint reasonable {  // 限制测试长度
    run_for_n_frames inside {[1 : 100]};
  }

endclass
