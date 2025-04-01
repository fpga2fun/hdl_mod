class Transaction;
  bit [31:0] addr, csm, data[8];  // 实际数据
  static int count = 0;  // 不需要打包的数据
  int id;

  function new();
    id = count++;
  endfunction

  function void display();
    $write("Tr: id = %0d, addr = %x, csm = %x", id, addr, csm);
    foreach (data[i]) $write(" %x", data[i]);
    $display;
  endfunction

  function void pack(ref byte bytes[$]);
    bytes = {>>{addr, csm, data}};
  endfunction

  function Transaction unpack(ref byte bytes[$]);
    {>>{addr, csm, data}} = bytes;
  endfunction
endclass : Transaction
