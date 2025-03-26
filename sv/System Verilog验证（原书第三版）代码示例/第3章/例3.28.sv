`timescale 1ns/100ps
module ps;
 initial begin
 realtime rtdelay = 800ps; // 以 0.8 存储 （800ps）
 time tdelay = 800ps; // 舍入后为 1ns
 $timeformat(-12, 0, "ps", 5);
 #rtdelay; // 延时 800ps
 $display("%t", rtdelay); //"800ps"
 #tdelay; // 再次延时 1ns
 $display("%t", tdelay); //"1000ps"
 End
 endmodule
`timescale 1ns/1ns // 复位成默认值