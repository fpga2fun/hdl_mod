forever begin
 // 这是一个零时延循环！
 wait(handshake.triggered);
 $display("Received next event");
 process_in_zero_time();
end