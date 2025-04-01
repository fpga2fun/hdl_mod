program automatic test(Rx_if.TB Rx0, Rx1, Rx2, Rx3,
 Tx_if.TB Tx0, Tx1, Tx2, Tx3,
 output logic rst);
 bit [7:0] bytes[`ATM_SIZE];

 initial begin
 // 复位设备
 rst <= 1;
 Rx0.cb.data <= '0;
 ...
 receive_cell0;
 ...
 end

 task receive_cell0();
 @(Tx0.cb);
 Tx0.cb.clav <= 1; // 给出开始接收的信号
 wait (Tx0.cb.soc == 1); // 等待信元的开始

 for (int i = 0; i<`ATM_SIZE; i++) begin
 wait (Tx0.cb.en == 0); // 等待使能
 @(Tx0.cb);

 bytes[i] = Tx0.cb.data;
 @(Tx0.cb);
 Tx0.cb.clav <= 0; // 释放流控信号
 end
 endtask
 
endprogram