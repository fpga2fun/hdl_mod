initial begin
  typedef struct {
    int a;
    byte b;
    shortint c;
    int d;
  } my_struct_s;
  my_struct_s st = '{32'haaaa_aaaa, 8'hbb, 16'hcccc, 32'hdddd_dddd};
  byte b[];

  // 将结构转换成字节数组
  b  = {>>{st}};  // {aa aa aa aa bb cc cc dd dd dd dd}

  // 将字节数组转换成结构
  b  = '{8'h11, 8'h22, 8'h33, 8'h44, 8'h55, 8'h66, 8'h77, 8'h88, 8'h99, 8'haa, 8'hbb};
  st = {>>{b}};  // st = 11223344, 55, 6677, 8899aabb
end
