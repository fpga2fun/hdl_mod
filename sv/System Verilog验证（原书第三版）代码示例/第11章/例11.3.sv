interface cpu_ifc;
  logic BusMode, Sel, Rd_DS, Wr_RW, Rdy_Dtack;
  logic [11:0] Addr;
  CellCfgType DataIn, DataOut;  // 在例 11.11 中定义

  modport Peripheral(input BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW, output DataOut, Rdy_Dtack);

  modport Test(output BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW, input DataOut, Rdy_Dtack);

endinterface : cpu_ifc

typedef virtual cpu_ifc.Test vCPU_T;
