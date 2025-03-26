////////////////////////////////////////////////////////////////////////////////// 
// Purpose: Testbench for Chap_12_Interfacing_with_C/exercise2b_slide
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.sv,v $
// Revision 1.1  2011/09/27 19:36:23  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////////////////

module hello;
    import "DPI-C" function chandle hello_new(int);
    import "DPI-C" function void hello_c(input chandle inst);

   // Test two instances of hello
   initial begin
      chandle 	inst1, inst2; // Points to storage in C
      inst1 = hello_new(0);
      inst2 = hello_new(5);
      hello_c(inst1);
      hello_c(inst2);
      hello_c(inst1);
      hello_c(inst2);
      $finish;
   end // initial begin
endmodule
