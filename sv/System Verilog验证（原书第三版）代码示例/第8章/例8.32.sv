parameter int SIZE = 100;
class Stack #(
    type T = int
);
  local T   stack[SIZE];  // 保存数据值
  local int top;

  function void push(input T i);  // 从顶部入栈
    stack[top++] = i;
  endfunction : push

  function T pop();  // 从顶部出栈
    return stack[--top];
  endfunction
endclass : Stack
