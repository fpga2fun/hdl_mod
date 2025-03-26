//////////////////////////////////////////////////////////////
// Purpose: Package for Chap_5_Basic_OOP/exercise9
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/02 19:40:19  tumbush.tumbush
// Include Statistics object so that deep copy is required.
//
// Revision 1.1  2011/05/29 19:03:52  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:43:34  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////
package automatic my_package;
   
   class Statistics;
      time startT; // Transaction start time
      static int ntrans = 0; // Transaction count
      static time total_elapsed_time = 0;

      function void start();
         startT = $time;
      endfunction // void

      function void stop();
         time how_long = $time - startT;
         ntrans++; // Another trans completed
         total_elapsed_time += how_long;
      endfunction // void

      function Statistics copy();
        copy = new();              // Construct destination object
        copy.startT = startT;          // Fill in data values
      endfunction // Statistics

      function void print_start();
            $display("startT = 0x%0h", startT);
      endfunction // void

   endclass

   class MemTrans;	
      bit [7:0] data_in;
      bit [3:0] address;
      Statistics stats;

      function new();
         data_in = 3;
         address = 5;
         stats = new();
      endfunction

      function MemTrans copy();
         copy = new();
         copy.address = address;
         copy.data_in = data_in;
         copy.stats = stats.copy();
      endfunction // copy

      function void print();
         $display("Data_in = 0x%0h, address = 0x%0h", data_in, address);
      endfunction
      
   endclass


endpackage
