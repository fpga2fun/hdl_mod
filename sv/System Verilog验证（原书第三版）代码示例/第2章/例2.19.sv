int dyn[], d2[];  // 声明动态数组

initial begin
  dyn = new[5];  // A: 分配 5 个元素
  foreach (dyn[j]) dyn[j] = j;  // B: 对元素进行初始化
  d2 = dyn;  // C: 复制一个动态数组
  d2[0] = 5;  // D: 修改复制值
  $display(dyn[0], d2[0]);  // E: 显示数值 (0 和 5)
  dyn = new[20] (dyn);  // F: 分配 20 个整数值并进行复制
  dyn = new[100];  // G: 分配 100 个新的整数值
                   // 旧值不复存在
  dyn.delete();  // H: 删除所有元素
end
