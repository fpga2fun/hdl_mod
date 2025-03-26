clocking cb @(posedge clk);
  default input #15ns output #10ns;
  output request;
  input grant;
endclocking
