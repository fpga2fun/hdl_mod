/////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_5_Basic_OOP/exercise8
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:03:51  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:40:12  Greg
// Initial check-in
//
////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
 
   import  my_package::*;

   initial begin
      Transaction tarray[5];
      generator(tarray);
   end   

   task generator(ref Transaction gen_array[5]);
     foreach (gen_array[i]) 
       begin
	  gen_array[i] = new();
	  transmit(gen_array[i]);
       end
   endtask // generator

   task transmit(Transaction tr);
      $display("Transmitting Transaction object with addr = 0x%0h", tr.addr);
   endtask // transmit

   endprogram



