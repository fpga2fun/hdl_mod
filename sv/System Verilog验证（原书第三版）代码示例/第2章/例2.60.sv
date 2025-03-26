typedef enum {
  RED,
  BLUE,
  GREEN
} COLOR_E;
COLOR_E color, c2;
int c;

initial begin
  color = BLUE;  // 赋一个已知的合法值
  c = color;  // 将枚举类型转换成整型 (1)
  c++;  // 整型递增 (2)
  if (!$cast(color, c))  // 将整型显式转换回枚举类型
    $display("Cast failed for c=%0d", c);
  $display("Color is %0d / %s", color, color.name);
  c++;  // 3对于枚举类型已经越界
  c2 = COLOR_E'(c);  // 不做类型检查
  $display("c2 is %0d / %s", c2, c2.name());
end
