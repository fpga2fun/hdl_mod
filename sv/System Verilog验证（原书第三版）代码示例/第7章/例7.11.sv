initial begin
  for (int j = 0; j < 3; j++)
  fork
    automatic int k = j;  // 创建索引的拷贝
    begin
      $write(k);  // 打印拷贝值
    end
  join_none
  #0 $display;
end
