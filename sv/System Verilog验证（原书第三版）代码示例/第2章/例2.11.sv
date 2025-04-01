int md[2][3] = '{'{0, 1, 2}, '{3, 4, 5}};
initial begin
  $display("Initial value:");
  foreach (md[i, j])  // 这是正确的语法格式
  $display("md[%0d][%0d] = %0d", i, j, md[i][j]);

  $display("New value:");
  // 对最后三个元素重复赋值5
  md = '{'{9, 8, 7}, '{3{5}}};
  foreach (md[i, j])  // 这是正确的语法格式
  $display("md[%0d][%0d] = %0d", i, j, md[i][j]);
end
