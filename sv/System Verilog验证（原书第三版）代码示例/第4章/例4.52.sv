module incr (
    ref int c,
    d
);  // 变量
  always @(c) #1 d = c++;  //d = c; c = c+1;
endmodule

module top;
  int c, d;
  incr i1 (
      c,
      d
  );
  initial begin
    $monitor("@%0d: c = %0d, d = %0d", $time, c, d);
    c = 2;
    #10;
    c = 8;
    #10;
  end
endmodule
