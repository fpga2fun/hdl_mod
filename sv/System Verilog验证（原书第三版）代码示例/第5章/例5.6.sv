class Transaction;
  logic [31:0] addr, csm, data[8];

  function new(input logic [31:0] a = 3, d = 5);
    addr = a;
    data = '{default: d};
  endfunction
endclass

initial begin
  Transaction tr;
  tr = new(.a(10));  // a = 10, d 使用默认值 5
end
