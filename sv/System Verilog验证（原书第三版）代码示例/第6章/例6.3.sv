class Child;
  bit [7:0] age;  // 错误 – 应该用 rand 或 randc
  constraint c_teenager {
    age > 12;
    age < 20;
  }
endclass
