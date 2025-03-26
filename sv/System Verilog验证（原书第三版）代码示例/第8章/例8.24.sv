virtual class BaseTr;
  static int count;  // 需要创建的实例数
  int id;  // 唯一的事务 ID

  function new();
    id = count++;  // 每一个对象对应一个 ID
  endfunction

  pure virtual function bit compare(input BaseTr to);
  pure virtual function BaseTr copy(input BaseTr to = null);
  pure virtual function void display(input string prefix = "");
endclass : BaseTr
