////////////////////////////////////////////////////////
// Purpose: Solution for Chap_2_Data_Types/exercise10
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/07 17:08:11  tumbush.tumbush
// Use _e nomenclature on enumerated types.
//
// Revision 1.1  2011/05/28 19:48:05  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/05 22:20:23  Greg
// Initial check-in
//
////////////////////////////////////////////////////////

`default_nettype none
  module test;

   // a) Create a user defined type, nibble, of 4 bits
   typedef   bit [3:0] nibble_e;

   // b) Create a real variable, r,  and initialize it to 4.33
   real      r = 4.33;

   // c) Create a short int variable, i_pack
   shortint i_pack;

   // d) Create an unpacked array, k, containing 4 elements of your
   // user defined type and initialize it to 0, F, E, and D
   nibble_e k[4] = '{4'h0, 4'hF, 4'hE, 4'hD}; // unpacked
   
initial begin
   // e) Print out k
   $display("k=%p", k); // # k='{0, 15, 14, 13}

   // f) Stream k into i_pack right to left on a bit basis
    i_pack={ << {k}};
   $display("i_pack= %h", i_pack); // # i_pack= b7f0

   // g) Stream k into i_pack right to left on a nibble basis and print it out
   i_pack={ << nibble_e {k}};
   $display("i_pack= %h", i_pack); // # i_pack= def0

   // h) type convert real r into a nibble, assign it to k[0], and print out k
   k[0] = nibble_e'(r);
   // k[0] = r; // This works too
   $display("k=%p", k); // # k='{4, 15, 14, 13}

   $finish;
   
end

endmodule // test

