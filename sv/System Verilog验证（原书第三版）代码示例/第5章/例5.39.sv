Transaction tr, tr2;
byte b[$];  // 字节队列

initial begin
  tr = new();
  tr.addr = 32'ha0a0a0a0;  // 填充对象
  tr.csm = '1;
  foreach (tr.data[i]) tr.data[i] = i;

  tr.pack(b);  // 打包对象到字节数组
  $write("Pack results: ");
  foreach (b[i]) $write("%h", b[i]);
  $display;

  tr2 = new();
  tr2.unpack(b);
  tr2.display();
end
