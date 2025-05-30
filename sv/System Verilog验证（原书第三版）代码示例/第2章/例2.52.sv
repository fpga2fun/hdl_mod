initial begin
  bit [15:0] wq[$] = {16'h1234, 16'h5678};
  bit [ 7:0] bq[$];

  // 把字数组转换成字节数组
  bq = {>>{wq}};  // 12 34 56 78

  // 把字节数组转换成字数组
  bq = {8'h98, 8'h76, 8'h54, 8'h32};
  wq = {>>{bq}};  // 9876 5432
end
