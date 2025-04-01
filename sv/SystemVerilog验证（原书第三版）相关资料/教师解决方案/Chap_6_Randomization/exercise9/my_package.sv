///////////////////////////////////////////////////////
// Purpose: Package for Chap_6_Randomization/exercise9
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/06 18:53:25  tumbush.tumbush
// Generate 20 transactions and print out the size of each transaction.
//
// Revision 1.1  2011/05/29 19:10:03  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 19:56:06  Greg
// Initial check-in
//
//////////////////////////////////////////////////////
package my_package;

class StimData;
  rand int data[];
  constraint c {data.size() inside {[1:1000]}; }
  
      function void print_size;
	 $display("Created an %0d element array", data.size());
      endfunction //

   function void print_element(int index);
      $display("data[0d%0d] = 0x%0x", index, data[index]); 
   endfunction // print_element
   
      
   endclass

endpackage
