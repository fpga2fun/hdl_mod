class Config;
  int nErrors, nWarnings;  // 错误和警告的个数
  bit [31:0] numRx, numTx;  // 把参数复制一份

  rand bit [31:0] nCells;  // 信元的总数
  constraint c_nCells_valid {nCells > 0;}
  constraint c_nCells_reasonable {nCells < 1000;}
  rand bit in_use_Rx[];  // 允许使用的输入 / 输出通道
  constraint c_in_use_valid {in_use_Rx.sum > 0;}  // 至少需要一个 RX 通道

  rand bit [31:0] cells_per_chan[];
  constraint c_sum_ncells_sum  // 把信元分配到各个通道
  {
    cells_per_chan.sum() == nCells;
  }  // 各通道信元的总数等于 nCells

  // 把未使用的通道的信元个数设为 0
  constraint zero_unused_channels {
    foreach (cells_per_chan[i]) {
      //in_use 均匀分布时，先求解 in_use_Rx[]
      solve in_use_Rx[i] before cells_per_chan[i];
      if (in_use_Rx[i])
      cells_per_chan[i] inside {[1 : nCells]};
      else
      cells_per_chan[i] == 0;
    }
  }

  extern function new(input bit [31:0] numRx, numTx);
  extern virtual function void display(input string prefix = "");
endclass : Config
