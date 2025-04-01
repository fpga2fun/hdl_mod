program automatic bug;

  class Buggy;
    int data[10];
    task transmit();
      fork
        for (i = 0; i < 10; i++)  //i 在这里并没有声明
        send(data[i]);
      join_none
    endtask
  endclass

  int   i;  // 共享的程序级变量 i
  Buggy b;
  event receive;

  initial begin
    b = new();
    for (i = 0; i < 10; i++)  //i 在这里没有声明
    b.data[i] = i;
    b.transmit();
    for (i = 0; i < 10; i++)  //i 在这里没有声明
    @(receive) $display(b.data[i]);
  end
endprogram
