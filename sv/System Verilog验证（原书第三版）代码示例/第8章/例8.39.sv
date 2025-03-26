class Print;
  static bit [31:0] error_count = 0, error_limit = -1;
  static function void error(input string ID, input string message);
    $display("@%0t %m [%s] %s", $realtime, ID, message);
    error_count++;
    if (error_count >= error_limit) begin
      $display("Maximum error limit reached");
      $finish;
    end
  endfunction
endclass
