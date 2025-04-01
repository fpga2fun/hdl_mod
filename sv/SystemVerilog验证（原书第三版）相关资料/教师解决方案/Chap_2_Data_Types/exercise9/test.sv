////////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog code for Chap_2_Data_Types/exercise9
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.4  2011/09/15 23:07:55  tumbush.tumbush
// Changed _u to _t
//
// Revision 1.3  2011/09/08 19:43:01  tumbush.tumbush
// Provided alternate solution
//
// Revision 1.2  2011/09/07 16:33:30  tumbush.tumbush
// Added _u to typedef
//
// Revision 1.1  2011/05/28 19:48:14  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/05 22:19:37  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////

`default_nettype none
  module test;

   typedef bit [6:0] bit7_t;

   typedef struct    {	    
      bit7_t header;
      bit7_t cmd;
      bit7_t data;
      bit7_t crc;
   } packet;

   // packet my_packet = '{7'h5A, 0, 0, 0}; // Can do this instead of assigning in initial block.
   packet my_packet;

   initial begin
      my_packet.header = 7'h5A;
      #10ns;
      $display("my_packet.header = 0x%0h ", my_packet.header);
      $display("my_packet.cmd = 0x%0h ", my_packet.cmd);
      $display("my_packet.data = 0x%0h ", my_packet.data);
      $display("my_packet.crc = 0x%0h ", my_packet.crc);
      
      $finish;
   end

endmodule // test

