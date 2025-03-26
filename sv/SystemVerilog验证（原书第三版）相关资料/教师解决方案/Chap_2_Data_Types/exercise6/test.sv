////////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog code for Chap_2_Data_Types/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 19:48:10  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.2  2011/05/19 18:16:27  Greg
// Break up declartion and assignment of street to match exercise statement.
//
// Revision 1.1  2011/05/04 17:34:28  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////
`default_nettype none
module test;
   // string street[$] = {"Tejon", "Bijou", "Boulder"};
   string street[$];
initial begin
   street = {"Tejon", "Bijou", "Boulder"};
   $display("Street[0] = %s", street[0]); 
   street.insert(2, "Platte");
   $display("Street[2] = %s", street[2]);
   street.push_front("St. Vrain");
   $display("Street[2] = %s", street[2]);
   $display("pop_back = %s", street.pop_back);
   $display("street.size = %0d", street.size);
   $finish;
end

endmodule // test

