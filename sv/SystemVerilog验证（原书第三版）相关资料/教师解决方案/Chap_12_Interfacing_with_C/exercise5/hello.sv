//////////////////////////////////////////////////////////////////////
// Purpose: Top level module for Chap_12_Interfacing_with_C/exercise5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.sv,v $
// Revision 1.3  2011/05/30 20:33:06  tumbush.tumbush
// Renamed hello C++ function to hello_c
//
// Revision 1.2  2011/05/29 20:24:46  tumbush.tumbush
// Added $finish to end of initial block.
//
// Revision 1.1  2011/05/29 20:18:33  tumbush.tumbush
// Check into cloud repository.
//
// Revision 1.1  2011/04/29 01:49:28  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////
   
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
