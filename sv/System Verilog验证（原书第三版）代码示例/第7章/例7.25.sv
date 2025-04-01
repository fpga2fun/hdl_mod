forever begin
 // 这里避免了零时延循环！
 @handshake;
 $display("Received next event");
 process_in_zero_time();
end