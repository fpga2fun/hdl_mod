class RandcInside;
  int array[];  // 待选取的值
  randc bit [15:0] index;  // 数组的索引

  function new(input int a[]);  // 构造、初始化
    array = a;
  endfunction

  function int pick();  // 返回刚选取的值
    return array[index];
  endfunction

  constraint c_size {index < array.size();}
endclass
