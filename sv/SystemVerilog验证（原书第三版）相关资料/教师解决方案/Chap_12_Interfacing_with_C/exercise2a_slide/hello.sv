////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_12_Interfacing_with_C/exercise2a_slide
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.sv,v $
// Revision 1.1  2011/09/27 19:35:14  tumbush.tumbush
// Initial check-in
//
//
////////////////////////////////////////////////////////////////////////////////
   
module hello;
    import "DPI-C" function chandle hello_new();
    import "DPI-C" function void hello_c(input chandle inst);

   // Test two instances of hello
   initial begin
      chandle 	inst1, inst2; // Points to storage in C
      inst1 = hello_new();
      inst2 = hello_new();
      hello_c(inst1);
      hello_c(inst2);
      hello_c(inst1);
      hello_c(inst2);
      $finish;
   end // initial begin
endmodule
