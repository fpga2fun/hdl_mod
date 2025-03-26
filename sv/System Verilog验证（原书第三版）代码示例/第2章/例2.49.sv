module test;
  import ABC::*;  // 寻找 ABC 里的符号
  import XYZ::timeout;  // 只导入 timeout
  string message = "Test timed out";  // 隐藏了 ABC 中的 message

  initial begin
    #(timeout);  // 来自 XYZ
    $display("Timeout - %s", message);
    $finish;
  end
endmodule
