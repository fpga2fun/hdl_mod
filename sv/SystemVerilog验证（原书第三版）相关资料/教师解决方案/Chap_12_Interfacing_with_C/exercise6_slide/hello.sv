/////////////////////////////////////////////////////////////////////////
// Purpose: Top level module for Chap_12_Interfacing_with_C/exercise6_slide
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.sv,v $
// Revision 1.1  2011/09/27 19:54:23  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////////
   
module hello;
   import "DPI-C" context function void hello();
   export "DPI-C" function hello_build;
   export "DPI-C" function hello_sv;

   class Hello;
      function void hello_sv();
         $display("SV: Hello World");
      endfunction // hello_sv
   endclass // Hello

   Hello helloq[$]; // Queue of Hello objects

   function void hello_build();
      Hello h;
      h = new();
      helloq.push_back(h);
   endfunction // hello_build

   function void hello_sv(input int idx);
      helloq[idx].hello_sv();
   endfunction // hello_sv

   initial begin
      hello();
      $finish;
   end
   
endmodule
