/////////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Golden model for Chap_7_Threads_and_Interprocess_Communication/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: golden.sv,v $
// Revision 1.1  2011/05/29 19:13:48  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/18 20:10:32  Greg
// Initial checkin
//
/////////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  module golden(
		input bit clk,
		input bit reset,
		input bit [2:0] req,
		input bit [2:0] en,
		output bit [2:0] grant
		);
   bit [2:0] 			 port_priority;

   enum logic [2:0] {NONE = 3'b000, PORT2 = 3'b100, PORT1 = 3'b010, PORT0 = 3'b001} grant_e;

   
   // Ring token to keep track of port_priority
   // If grant is asserted, increment port_priority
   always @(posedge clk or posedge reset) begin
      if (reset)
	port_priority <= PORT0;
      else if (grant != 0) begin
	 port_priority[0] <= port_priority[2];
         port_priority[2:1] <= port_priority[1:0];
      end
   end

   always @* begin
      case (port_priority)
	PORT0: begin
	   if (en[0] && req[0])
	     grant = PORT0;
	   else if (en[1] && req[1])
	     grant = PORT1;
	   else if (en[2] && req[2])
	     grant = PORT2;
	   else
	     grant = NONE;
	end
	PORT1: begin
	   if (en[1] && req[1])
	     grant = PORT1;
	   else if (en[2] && req[2])
	     grant = PORT2;
	   else if (en[0] && req[0])
	     grant = PORT0;
	   else
	     grant = NONE;
	end
	PORT2: begin
	   if (en[2] && req[2])
	     grant = PORT2;
	   else if (en[0] && req[0])
	     grant = PORT0;
	   else if (en[1] && req[1])
	     grant = PORT1;
	   else
	     grant = NONE;
	end
      endcase // case (port_priority)
   end // always @ *

endmodule // golden









