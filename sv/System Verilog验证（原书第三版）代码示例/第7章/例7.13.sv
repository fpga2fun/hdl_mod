program automatic bug_free;
  initial begin
    for (int j = 0; j < 3; j++) begin
      automatic int k = j;  // 拷贝索引
      fork
        begin
          $write(k);  // 打印拷贝
        end
      join_none
    end
    #0 $display;  // 所有线程结束后另起一行
  end
endprogram
