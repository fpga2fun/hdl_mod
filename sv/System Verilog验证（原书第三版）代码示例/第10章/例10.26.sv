// 带有装载和低电平复位输入的 N 位计数器。
module counter #(BIT_WIDTH = 8) (X_if.DUT xi);
 logic [BIT_WIDTH-1:0] count;
...