module arb_with_ifc (
    arb_if arbif
);
  always @(posedge arbif.clk or posedge arbif.rst) begin
    if (arbif.rst) arbif.grant <= '0;
    else if (arbif.request[0])  // 高优先级
      arbif.grant <= 2'b01;
    else if (arbif.request[1])  // 低优先级
      arbif.grant <= 2'b10;
    else arbif.grant <= '0;
  end
endmodule
