class Rising;
  bit [7:0] low;  // 非随机变量
  rand bit [7:0] med, hi;  // 随机变量
  constraint up {
    low < med;
    med < hi;
  }  // 见 6.4.2 节
endclass

initial begin
  Rising r;
  r = new();
  r.randomize();  // 随机化 med, hi；但不改变 low
  r.randomize(med);  // 随机化 med
  r.randomize(low);  // 随机化 low，即使不是随机变量
end
