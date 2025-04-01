module test;
  import ABC::*;  // 寻找 ABC 里的符号
  abc_data_t data;  //abc_data_t 来自包 ABC
  string message = "Test timed out";  // 本地的 message 隐藏了包 ABC 里的 message 符号
  initial begin
    #(timeout);  //timeout 来自包 ABC
    $display("Timeout - %s", message);
    $finish;
  end
endmodule
