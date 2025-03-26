initial begin
  Stack #(real) rStack;  // 创建一个实数类型的堆栈
  rStack = new();  // 构造实数栈对象
  for (int i = 0; i < SIZE; i++) rStack.push(i * 2.0);  // 数据入栈

  for (int i = 0; i < SIZE; i++) $display("%f ", rStack.pop());  // 数据出栈
end
