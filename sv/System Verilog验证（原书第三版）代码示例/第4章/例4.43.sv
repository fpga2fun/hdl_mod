interface arb_if (
    input bit clk
);
  logic [1:0] grant, request;
  bit rst;
  property request_2state;
    @(posedge clk) disable iff (rst) $isunknown(
        request
    ) == 0;  // 确保没有 Z 或者 X 值存在
  endproperty
  assert_request_2state :
  assert property (request_2state);
endinterface
