program automatic test(Rx_if.TB Rx0, Rx1, Rx2, Rx3,
 Tx_if.TB Tx0, Tx1, Tx2, Tx3,
 input logic clk, output bit rst);
 bit [7:0] bytes[ATM_CELL_SIZE];
 initial begin
 // 复位设备
 rst <= 1;
 Rx0.cb.data <= 0;
 ...
 receive_cell0();
 ...
 end
task receive_cell0();
 @(Tx0.cb);
 Tx0.cb.clav <= 1; // 准备接收
 wait (Tx0.cb.soc == 1); // 等待信元的开始
 foreach (bytes[i]) begin
    wait (Tx0.cb.en == 0); // 等待使能信号
 @(Tx0.cb);
 bytes[i] = Tx0.cb.data;
 @(Tx0.cb);
 Tx0.cb.clav <= 0; // 释放流控信号
 end
 endtask : receive_cell0
endprogram : test