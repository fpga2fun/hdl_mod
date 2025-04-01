function void build();
  pci_gen gen0, gen1;
  atm_gen new_gen;  // 新的 ATM 发生器
  gen0 = new();
  gen1 = new();
  new_gen = new();  // 在已有的对象后创建新的对象

  fork
    gen0.run();
    gen1.run();
    new_gen.run();  // 在已有的线程后产生新的线程
  join
endfunction : build
