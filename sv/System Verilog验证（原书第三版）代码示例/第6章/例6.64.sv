// 产生 0:max-1 之间唯一的随机值
class RandcRange;
  randc bit [15:0] value;
  int max_value;  // 最大值
  function new(input int max_value = 10);
    this.max_value = max_value;
  endfunction

  constraint c_max_value {value < max_value;}
endclass
