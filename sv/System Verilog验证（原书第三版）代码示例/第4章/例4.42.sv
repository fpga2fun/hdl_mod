a42: assert (arbif.cb.grant == 2'b01)
 grants_received++; // 另一个成功的结果
else
 $error("Grant not asserted");