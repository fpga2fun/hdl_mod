/* 输入文件的内容如下：
 42 min_address
 1492 max_address
*/

int switch[string], min_address, max_address, i, file;
initial begin
  string s;
  file = $fopen("switch.txt", "r");
  while (!$feof(
      file
  )) begin
    $fscanf(file, "%d %s", i, s);
    switch[s] = i;
  end
  $fclose(file);

  // 获取最小地址值
  // 如果找不到字符串，对于 int 数组返回默认值 0
  min_address = switch["min_address"];

  // 获取最大地址值
  // 如果 max_address 不存在，返回 1000
  if (switch.exists("max_address")) max_address = switch["max_address"];
  else max_address = 1000;

  // 打印数组所有元素
  foreach (switch[s]) $display("switch['%s'] = %0d", s, switch[s]);
end
