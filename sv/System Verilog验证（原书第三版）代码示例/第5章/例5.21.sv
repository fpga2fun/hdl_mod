class Scoping;
  string name;

  function new(input string name);
    this.name = name;  // 类变量 name = 局部变量 name
  endfunction

endclass
