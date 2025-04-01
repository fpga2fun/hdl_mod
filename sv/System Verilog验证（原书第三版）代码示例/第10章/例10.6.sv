program automatic test(Rx_if.TB Rx[4], Tx_if.TB Tx[4],
 output logic rst);
...
 initial begin
 foreach (scb[i]) begin
 scb[i] = new(i);
 drv[i] = new(scb[i].exp_mbx, i, Rx[i]);
 mon[i] = new(scb[i].rcv_mbx, i, Tx[i]);
 end
 ...
 end
endprogram