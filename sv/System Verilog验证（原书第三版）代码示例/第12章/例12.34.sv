module block;
  import "DPI-C" context function void c_display();
  export "DPI-C" function sv_display;  // 没有类型定义或者参数

  initial c_display();

  function void sv_display();
    $display("SV: in sv_display");
  endfunction
endmodule : block
