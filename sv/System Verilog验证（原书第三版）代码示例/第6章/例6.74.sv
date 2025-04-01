function void build();
  pci_gen gen0, gen1;
  gen0 = new();
  gen1 = new();
  fork
    gen0.run();
    gen1.run();
  join
endfunction : build
