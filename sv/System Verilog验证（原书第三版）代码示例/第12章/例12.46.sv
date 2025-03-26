module top;
  import "DPI-C" context function void c_display();
  export "DPI-C" function sv_display;

  block b1 ();
  initial c_display();

  function void sv_display();
    $display("SV: In %m");
  endfunction
endmodule : top

module block;
  import "DPI-C" context function void c_display();
  export "DPI-C" function sv_display;

  initial c_display();

  function void sv_display();
    $display("SV: In %m");
  endfunction
endmodule : block
