module block;
  import "DPI-C" context function void c_display();
  import "DPI-C" context function void save_my_scope();
  export "DPI-C" function sv_display;
  function void sv_display();
    $display("SV: In %m");
  endfunction : sv_display
  initial begin
    save_my_scope();
    c_display();
  end
endmodule : block
module top;
  import "DPI-C" context function void c_display();
  export "DPI-C" function sv_display;
  function void sv_display();
    $display("SV: In %m");
  endfunction : sv_display
  block b1 ();
  initial #1 c_display();
endmodule : top
