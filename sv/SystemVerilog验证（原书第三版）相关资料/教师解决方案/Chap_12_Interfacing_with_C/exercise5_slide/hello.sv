//////////////////////////////////////////////////////////////////////
// Purpose: Top level module for Chap_12_Interfacing_with_C/exercise5_slide
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.sv,v $
// Revision 1.1  2011/09/27 19:50:27  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////
module hello;
   import "DPI-C" context function void hello();
   export "DPI-C" function hello_sv;

    initial begin
	hello();
        $finish;
     end

   function void hello_sv();
      $display("SV: Hello World");
   endfunction // hello_sv

endmodule
