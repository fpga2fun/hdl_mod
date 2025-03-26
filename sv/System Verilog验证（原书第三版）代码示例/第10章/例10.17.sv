// 带有装载和低电平复位输入的 8 位计数器
module counter (
    X_if.DUT xi
);
  logic [7:0] count;
  assign xi.dout = count;

  always @(posedge xi.clk or negedge xi.reset_l) begin
    if (!xi.reset_l) count <= '0;
    else if (xi.load) count <= xi.din;
    else count <= count + 1;
  end
endmodule
