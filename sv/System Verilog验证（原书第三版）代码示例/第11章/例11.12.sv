function Config::new(input bit [31:0] numRx, numTx);
  this.numRx = numRx;
  in_use_Rx = new[numRx];
  this.numTx = numTx;
  cells_per_chan = new[numRx];
endfunction : new

function void Config::display(input string prefix);
  $write("%sConfig: numRx = %0d, numTx = %0d, nCells = %0d (", prefix, numRx, numTx, nCells);
  foreach (cells_per_chan[i]) $write("%0d ", cells_per_chan[i]);
  $write("), enabled RX: ", prefix);
  foreach (in_use_Rx[i]) if (in_use_Rx[i]) $write("%0d ", i);
  $display;
endfunction : display
