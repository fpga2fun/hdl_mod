module arb_with_port (
    output logic [1:0] grant,
    input logic [1:0] request,
    input bit rst,
    clk
);

  always @(posedge clk or posedge rst) begin
    if (rst) grant <= 2'b00;
    else if (request[0])  // 高优先级
      grant <= 2'b01;
    else if (request[1])  // 低优先级
      grant <= 2'b10;
    else grant <= '0;
  end
endmodule
