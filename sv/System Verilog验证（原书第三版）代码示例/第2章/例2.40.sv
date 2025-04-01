typedef int fixed_array5_t[5];
fixed_array5_t f5;  // 和 “int f5[5]” 等价
initial begin
  foreach (f5[i]) f5[i] = i;
end
