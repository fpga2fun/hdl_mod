program automatic test(Rx_if.TB Rx0, Rx1, Rx2, Rx3,
 Tx_if.TB Tx0, Tx1, Tx2, Tx3,
 output logic rst);
 Driver drv[4];
 Monitor mon[4];
 Scoreboard scb[4];

 virtual Rx_if.TB vRx[4] = '{Rx0, Rx1, Rx2, Rx3};
 virtual Tx_if.TB vTx[4] = '{Tx0, Tx1, Tx2, Tx3};
 
 initial begin
 foreach (scb[i]) begin
 scb[i] = new(i);
 drv[i] = new(scb[i].exp_mbx, i, vRx[i]);
 mon[i] = new(scb[i].rcv_mbx, i, vTx[i]);
 end
 ...
 end
endprogram