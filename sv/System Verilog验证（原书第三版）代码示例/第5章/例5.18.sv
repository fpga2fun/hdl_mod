program automatic top;
  int limit;  //$root.top.limit

  class Foo;
    int limit, array[];  //$root.top.Foo.limit

    //$root.top.Foo.print.limit
    function void print(input int limit);
      for (int i = 0; i < limit; i++) $display("%m: array[%0d] = %0d", i, array[i]);
    endfunction
  endclass

  initial begin
    int limit = 3;
    Foo bar;

    bar = new();
    bar.array = new[limit];
    bar.print(limit);
  end
endprogram
