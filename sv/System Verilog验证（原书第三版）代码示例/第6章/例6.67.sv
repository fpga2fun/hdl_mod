parameter MAX_SIZE = 10;

class RandStuff;
  rand bit [31:0] value;
endclass

class RandArray;
  rand RandStuff array[];  // 不要忘记使用 rand!

  constraint c {array.size() inside {[1 : MAX_SIZE]};}

  function new();
    array = new[MAX_SIZE];  // 按最大的容量分配
    foreach (array[i]) array[i] = new();
  endfunction
  ;
endclass

RandArray ra;
initial begin
  ra = new();  // 构造数组和所有对象
  `SV_RAND_CHECK(ra.randomize());  // 随机化，可能会减小数组
  foreach (ra.array[i]) $display(ra.array[i].value);
end
