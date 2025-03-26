//////////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Arbiter model for Chap_7_Threads_and_Interprocess_Communication/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: arbiter.v,v $
// Revision 1.1  2011/05/29 19:13:48  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/18 20:10:32  Greg
// Initial checkin
//
//////////////////////////////////////////////////////////////////////////////////////////////
// Model for a 3-port arbiter using a round robin approach
// to issuing grant. 
// 1 Priority is maintained in a round robin format, i.e. port 0->port 1->port 2->port 0…   
// 2 At reset the priority is port 0.
// 3 Priority will be incremented whenever any grant is asserted
// 4 Grant is combinatorial
// 5 If a port with priority is not enabled or not currently requesting the next port will 
// be given the grant given that port is enabled and requesting the bus, and so on.
`default_nettype none
  module arbiter(	 
			 input wire clk,
			 input wire reset,
			 input wire req0,
			 input wire req1,
			 input wire req2,
			 input wire en0,
			 input wire en1,
			 input wire en2,
			 output reg grant0,
			 output reg grant1,
			 output reg grant2
			 );
   
`protect

   localparam NONE  = 3'b000,
     PORT0 = 3'b001,
     PORT1 = 3'b010,
     PORT2 = 3'b100;

   reg [2:0] 			    priority;

   always @* begin
      case (priority)
	PORT0: begin
	   if (en0 && req0)
	     {grant2, grant1, grant0} = PORT0;
	   else if (en1 && req1)
	     {grant2, grant1, grant0} = PORT1;
	   else if (en2 && req2)
	     {grant2, grant1, grant0} = PORT2;
	   else
	     {grant2, grant1, grant0} = NONE;
	end
	PORT1: begin
	   if (en1 && req1)
	     {grant2, grant1, grant0} = PORT1;
	   else if (en2 && req2)
	     {grant2, grant1, grant0} = PORT2;
	   else if (en0 && req0)
	     {grant2, grant1, grant0} = PORT0;
	   else
	     {grant2, grant1, grant0} = NONE;
	end
	PORT2: begin
	   if (en2 && req2)
	     {grant2, grant1, grant0} = PORT2;
	   else if (en0 && req0)
	     {grant2, grant1, grant0} = PORT0;
	   else if (en1 && req1)
	     {grant2, grant1, grant0} = PORT1;
	   else
	     {grant2, grant1, grant0} = NONE;
	end	 
        default: {grant2, grant1, grant0} = NONE;
      endcase // case (priority)
   end
   // end
   
   // Ring token to keep track of priority
   // If grant is asserted, increment priority
   always @(posedge clk or posedge reset) begin
      if (reset)
	priority <= 3'b001;
      else if (grant2 || grant1 || grant0) begin
	 priority[0] <= priority[2];
         priority[2:1] <= priority[1:0];
      end
   end

   //synopsys translate_off
   reg [95:0] ASCII_priority;
   always @(priority) begin
      case(priority)
	PORT0: ASCII_priority = "PORT0";
	PORT1: ASCII_priority = "PORT1";
	PORT2: ASCII_priority = "PORT2";
      endcase
   end
   //synopsys translate_on
   
`endprotect   
   
endmodule



