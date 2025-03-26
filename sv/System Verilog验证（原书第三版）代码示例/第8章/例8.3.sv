class Base;
  int val;
  function new(input int val);  // 带有参数的构造函数
    this.val = val;
  endfunction
endclass

class Extended extends Base;
  function new(input int val);
    super.new(val);  // 必须是 new 函数的第一行
    // 构造函数的其他行为
  endfunction
endclass
