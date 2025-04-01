program no_auto;
  initial begin
    for (int j = 0; j < 3; j++)
    fork
      $write(j);  // 漏洞：打印最终的索引值
    join_none
    #0 $display;
  end
endprogram
