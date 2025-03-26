///////////////////////////////////////////////////////////////////
// Purpose: sram_control DUT for Chap_6_Randomization/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: sram_control.v,v $
// Revision 1.2  2011/10/10 16:03:54  tumbush.tumbush
// Added header.
//
//
///////////////////////////////////////////////////////////////////

`default_nettype none
module sram_control( 
  
  // AHB Bus I/O
  input wire HCLK,
  input wire [20:0] HADDR,
  input wire HWRITE,
  input wire [7:0] HWDATA,
  input wire [1:0] HTRANS,
  
  output reg [7:0] HRDATA,
  
  // SRAM I/O
  inout wire [7:0] DQ,
  output reg CE_b, 
  output reg WE_b, 
  output reg OE_b,
  output reg [20:0] A,
  
  input wire reset
  );
  
  // Delay the address by 1 clock cycle
  reg [20:0] HADDR_q;
  
  // Reg to assign data out values to
  reg [7:0] DQ_reg;
  
  parameter IDLE = 2'b00,
           WRITE = 2'b01,
           READ = 2'b10;
           
  parameter HTRANS_IDLE = 2'b00;
  parameter HTRANS_NONSEQ = 2'b10;        
  
  reg [1:0] current_state, next_state;
  
  assign DQ = DQ_reg;
  
   always @* begin
     // Defaults
     DQ_reg   = 8'hZ;
     CE_b = 1'b1; 
     WE_b = 1'b1; 
     OE_b = 1'b1;
     // A    = 21'b0;
     HRDATA = 8'b0;
     case (current_state)
       IDLE: begin
         if (HTRANS == HTRANS_NONSEQ) begin
           if (HWRITE)
             next_state = WRITE;
           else
             next_state = READ;
         end
       else
         next_state = IDLE;
       end
       // Do the write on the SRAM
       WRITE: begin
         //A = HADDR_q;
         CE_b = 1'b0; 
         WE_b = 1'b0;
         DQ_reg = HWDATA;
         if (HTRANS == HTRANS_NONSEQ) begin
           if (HWRITE)
             next_state = WRITE;
           else
             next_state = READ;
         end
       else
         next_state = IDLE;
       end
       // Do the read on the SRAM
       READ: begin
         // A = HADDR_q;
         CE_b = 1'b0; 
         OE_b = 1'b0;
         HRDATA = DQ;
         if (HTRANS == HTRANS_NONSEQ) begin
           if (HWRITE)
             next_state = WRITE;
           else
             next_state = READ;
         end
       else
         next_state = IDLE;
       end
       default: next_state = IDLE;
     endcase
   end // always
   
   // Current_state = next state on the active edge of the clock
   always @(posedge HCLK or posedge reset) begin
     if (reset)
       current_state <= IDLE;
     else
       current_state <= next_state;
   end
   
  // Delay the address by 1 clock cycle
  always @(posedge HCLK or posedge reset) begin
     if (reset)
       //HADDR_q <= 21'b0;
       A <= 21'b0;
     else
       //HADDR_q <= HADDR;
       A <= HADDR;
  end
  
  //synopsys translate_off
  reg [95:0] ASCII_current_state;
  always @(current_state) begin
    case(current_state)
      IDLE: ASCII_current_state = "IDLE";
      WRITE: ASCII_current_state = "WRITE";
      READ: ASCII_current_state = "READ";
    endcase
  end 
  //synopsys translate_on
  
endmodule
  
  
  
