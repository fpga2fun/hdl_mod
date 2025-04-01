parameter int SIZE = 100;
class IntStack;
  local int stack[SIZE];  // 保存数据值
  local int top;

  function void push(input int i);  // 从顶端入栈
    stack[top++] = i;
  endfunction : push

  function int pop();  // 从顶端出栈
    return stack[--top];
  endfunction

endclass : IntStack
