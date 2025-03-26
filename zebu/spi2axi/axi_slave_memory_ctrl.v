//----------------------------------------------------------------------
// COPYRIGHT SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//----------------------------------------------------------------------

`protect
module AXI_SLAVE_MEMORY_CTRL(
// Global inputs
   ACLK,
   ARESETn,
 //write address channel 
   AXI_AWID,
   AXI_AWADDR,
   AXI_AWLEN,
   AXI_AWSIZE,
   AXI_AWBURST,
   AXI_AWLOCK,
   AXI_AWCACHE,
   AXI_AWPROT,
   AXI_AWVALID,
   AXI_AWREADY,

// Write Channel

   AXI_WLAST,
   AXI_WSTRB,
   AXI_WVALID,
   AXI_WREADY,

// Write Response Channel

   AXI_BID,

   AXI_BRESP,
   AXI_BVALID,
   AXI_BREADY,


// Read Address Channel

   AXI_ARID,

   AXI_ARADDR,
   AXI_ARLEN,
   AXI_ARSIZE,
   AXI_ARBURST,
   AXI_ARLOCK,
   AXI_ARCACHE,
   AXI_ARPROT,
   AXI_ARVALID,
   AXI_ARREADY,

// Read Channel

   AXI_RID,

   AXI_RRESP,
   AXI_RLAST,
   AXI_RVALID,
   AXI_RREADY,
// signals for controlling memory 
   addr,
   we,
   en,
   be
);


parameter DATA_WIDTH   = 32;
parameter ID_WIDTH     = 16;

parameter WSTRB_WIDTH  = DATA_WIDTH/8;

parameter WREADY_DELAY = 0; // Delay before having first WREADY chunk ready

input         ACLK;                       // AXI Clock
input         ARESETn;                    // AXI Reset

 // SlaveInterface 1 (connects to Master 1)


input [ID_WIDTH-1:0] AXI_AWID;                     // write addressID

input  [31:0] AXI_AWADDR;                   // write address
input  [7:0]  AXI_AWLEN;                    // write burst length
input  [2:0]  AXI_AWSIZE;                   // write burst size
input  [1:0]  AXI_AWBURST;                  // write burst type
input  [1:0]  AXI_AWLOCK;                   // write lock type
input  [3:0]  AXI_AWCACHE;                  // write cache type
input  [2:0]  AXI_AWPROT;                   // write protection level
input         AXI_AWVALID;                  // write address valid
output        AXI_AWREADY;                  // address ready



input         AXI_WLAST;                    // write last
input  [WSTRB_WIDTH-1:0] AXI_WSTRB;                    // write last
input         AXI_WVALID;                   // write valid
output        AXI_WREADY;                   // write ready



output [ID_WIDTH-1:0]  AXI_BID;                      // write response ID

output [1:0]  AXI_BRESP;                    // write response
output        AXI_BVALID;                   // write response valid
input         AXI_BREADY;                   // write response ready



input  [ID_WIDTH-1:0]  AXI_ARID;                     // read address id

input  [31:0] AXI_ARADDR;                   // read address
input  [7:0]  AXI_ARLEN;                    // read burst length
input  [2:0]  AXI_ARSIZE;                   // read burst size
input  [1:0]  AXI_ARBURST;                  // read burst type
input  [1:0]  AXI_ARLOCK;                   // read lock type
input  [3:0]  AXI_ARCACHE;                  // read cache type
input  [2:0]  AXI_ARPROT;                   // read protection level
input         AXI_ARVALID;                  // read address valid
output        AXI_ARREADY;                  // read address ready


output [ID_WIDTH-1:0]  AXI_RID;                      // read id

output [1:0]  AXI_RRESP;                    // read response
output        AXI_RLAST;                    // read last
output        AXI_RVALID;                   // read valid
input         AXI_RREADY;                   // read ready

output [31:0] addr;                
output        en;
output        we;
output [WSTRB_WIDTH-1:0] be;

wire          AXI_AWREADY;                  // address ready
wire          AXI_WREADY;                   // write ready
wire          AXI_BVALID;                   // write response valid
wire [1:0]    AXI_BRESP;                    // write response
wire          AXI_ARREADY;                  // read address ready
reg          AXI_ARREADY_r;                  // read address ready
wire [1:0]    AXI_RRESP;                    // read response
wire          AXI_RLAST;                    // read last
wire          AXI_RVALID;                   // read valid

reg [ID_WIDTH-1:0] AXI_RID;              // read id
reg [ID_WIDTH-1:0] AXI_BID;              // write response ID

reg [31:0]    WADDR;   
reg [31:0]    RADDR;
reg [7:0]     WLEN;
reg [7:0]     RLEN;
reg [1:0]     WBURST;
reg [1:0]     RBURST;
reg [2:0]     WSIZE;
reg [2:0]     RSIZE;
reg           WLOCK;
reg           RLOCK;

reg [31:0]    addr;
reg [2:0]     bfmState;           
reg [8:0]     burstCounter;      
reg [7:0]     delay_cnt;
reg           writePending;   
reg           write_status;   
reg           readPending;    
reg           read_status;    
wire          mem_read_status;  
wire          mem_write_status; 

reg  [7:0]  AXI_AWLEN_r;                    
reg  [7:0]  AXI_ARLEN_r;                    // read burst length
reg  [1:0]  AXI_ARBURST_r;                  // read burst type
reg  [1:0]  AXI_AWBURST_r;               
reg  [31:0] AXI_AWADDR_r;                   
reg  [31:0] AXI_ARADDR_r;                  
// AXI READ/WRITE burst type 

`define FIXED 2'b00 
`define INCR  2'b01 
`define WRAP  2'b10 

///////////////////////////////////////////////////////////////////////////////
// AXI Write Word state machine
///////////////////////////////////////////////////////////////////////////////

`define BFM_IDLE       0
`define WRITE_ADDRESS  1  
`define WRITE_SEQUENCE 2  
`define BRESP          3  
`define READ_ADDRESS   4  
`define READ_SEQUENCE  5  
`define END_READ       6  



always @(posedge ACLK , negedge ARESETn)
begin 

  if(ARESETn==0) 
      begin 
            bfmState <= `BFM_IDLE;   
            writePending <= 1'b0;
            readPending <= 1'b0;
            delay_cnt <= 8'b0;
            burstCounter <= 8'h0;
            read_status <= 1'b0;
            write_status <= 1'b0;
      end
           else
                begin 
                    case (bfmState) 
                            `BFM_IDLE :  
                             begin
                                burstCounter <= 8'h0;
                                    if(AXI_AWVALID==1)
                                      begin     
                                          writePending <= 1'b1;
                                          bfmState <= `WRITE_ADDRESS;
                                          AXI_AWLEN_r  <= AXI_AWLEN;
                                          AXI_AWBURST_r <= AXI_AWBURST;
                                          AXI_AWADDR_r  <= AXI_AWADDR;
                                      end
                                          else if(AXI_ARVALID==1) 
                                                begin   
                                                   readPending <= 1'b1; 
                                                   bfmState <= `READ_ADDRESS;
                                                   AXI_ARLEN_r <= AXI_ARLEN; 
                                                   AXI_ARBURST_r <= AXI_ARBURST;
                                                   AXI_ARADDR_r  <= AXI_ARADDR;
                                                end
                             end      
                            `WRITE_ADDRESS :
                             begin 
                                    if(AXI_WVALID ==1)
                                        begin 
                                            write_status <= 1'b1; 
                                            bfmState <= `WRITE_SEQUENCE; 
                                        end
                                            if(AXI_ARVALID==1) 
                                              readPending <= 1'b1;

                             end       
                             `WRITE_SEQUENCE : 
                              begin 
                                    if(burstCounter == (AXI_AWLEN_r+1)) 
                                      begin
                                         burstCounter <=0;
                                         bfmState <= `BRESP;
                                         AXI_AWLEN_r <= 0;
                                         AXI_AWBURST_r <= 0;
                                      end  
                                    else 
                                      begin
                                        if (AXI_WVALID == 1)
                                        burstCounter <= burstCounter +1;
                                      end
                                    if(AXI_ARVALID==1)
                                          readPending <= 1'b1;
                              end
                             `BRESP :
                              begin
                                    write_status <= 1'b0;
                                    writePending <= 1'b0;
                                    if(AXI_BREADY ==1 ) 
                                      begin
                                         if(AXI_ARVALID | readPending) 
                                            bfmState <= `READ_ADDRESS;
                                         else
                                            bfmState <= `BFM_IDLE;
                                      end
                                          if(AXI_ARVALID==1)
                                            readPending <= 1'b1;
                             end
                             `READ_ADDRESS :
                              begin 
                                   if(AXI_RREADY) 
                                      begin
                                           if (AXI_ARLEN_r == 4'b0) 
                                              begin
                                                burstCounter <= 4'h0;
                                                bfmState <= `END_READ;
                                              end 
                                                 else 
                                                    begin
                                                      burstCounter <= burstCounter +1;
                                                      read_status <= 1'b1; 
                                                      bfmState <= `READ_SEQUENCE; 
                                                    end
                                      end
                                    if(AXI_AWVALID==1) 
                                          writePending <= 1'b1;
                              end
                            `READ_SEQUENCE : 
                             begin 
                                 if(AXI_RREADY) 
                                    begin     
                                      if(burstCounter == AXI_ARLEN_r)   
                                          begin
                                            bfmState <= `END_READ;
                                            read_status <= 1'b0;
                                            AXI_ARLEN_r <= 0;
                                            AXI_ARBURST_r <= AXI_ARBURST;
                                          end  
                                    else 
                                      begin
                                        burstCounter <= burstCounter +1;
                                      end
                                    end
                                    if(AXI_AWVALID==1)
                                         writePending <= 1'b1;
                             end
                            `END_READ :
                             begin
                                readPending <= 1'b0;
                                if(AXI_AWVALID==1 || writePending ==1 )
                                    begin 
                                        bfmState <= `WRITE_ADDRESS;
                                        burstCounter <= 8'h0;
                                        AXI_AWLEN_r  <= AXI_AWLEN;
                                        AXI_AWBURST_r <= AXI_AWBURST;
                                    end
                                    else 
                                        bfmState <= `BFM_IDLE;       
                             end 
               endcase
      end
end
// write control 
assign  AXI_AWREADY    = ~writePending ; 
assign  AXI_WREADY     = write_status ;
// write response 
assign  AXI_BVALID     = ((bfmState == `BRESP ) && (ARESETn == 1)) ? 1 : 0;
//read control 
assign  AXI_ARREADY    = ~readPending ; //  AXI_ARREADY_r ; //~(readPending && (bfmState == `READ_ADDRESS)) ;  
assign  AXI_RVALID     = (bfmState == `READ_SEQUENCE || bfmState == `END_READ) && (ARESETn == 1) ? 1 : 0 ;
assign AXI_RLAST       = (bfmState == `END_READ) && ((burstCounter == AXI_ARLEN_r) || (AXI_ARLEN_r == 8'b0));

//read response 
assign AXI_RRESP       = (bfmState == `END_READ ) ? AXI_ARLOCK : 2'b00 ;
//write response 
assign AXI_BRESP       = (bfmState ==`BRESP )   ?  AXI_AWLOCK : 2'b00 ;


always @(posedge ACLK or negedge ARESETn) 
  begin                     
    if(~ARESETn)
      begin 
            AXI_BID    <= {ID_WIDTH{1'b0}};
      end
    else if(AXI_AWVALID & AXI_AWREADY)
      begin
            AXI_BID <= AXI_AWID;
      end
  end
//reg  AXI_ARVALID_r ; 
//always @(posedge ACLK) 
//  begin 
//    AXI_ARREADY_r <=  ~readPending ;
//    AXI_ARVALID_r <=  AXI_ARVALID ;
//  end
always @(posedge ACLK or negedge ARESETn) 
  begin
    if(~ARESETn) 
      begin 
           AXI_RID    <= {ID_WIDTH{1'b0}};
      end
    else if(AXI_ARVALID & AXI_ARREADY)
      begin
           AXI_RID <= AXI_ARID;
      end
  end

assign mem_read_status = ( bfmState == `READ_ADDRESS || bfmState == `READ_SEQUENCE || bfmState == `END_READ) ? 1'b1 :1'b0 ;
assign mem_write_status= ( bfmState == `WRITE_ADDRESS || bfmState == `WRITE_SEQUENCE || bfmState == `BRESP) ? 1'b1 :1'b0 ;

// encoder for burst size  for read
reg [7:0] burst_size_read;
reg [7:0] burst_size_write;

always @(AXI_AWSIZE , AXI_ARSIZE )
  begin
     case (AXI_ARSIZE) 
         3'b000:burst_size_read  = 1;
         3'b001:burst_size_read  = 2;
         3'b010:burst_size_read  = 4;
         3'b011:burst_size_read  = 8;
         3'b100:burst_size_read  = 16;
         3'b101:burst_size_read  = 32;
         3'b110:burst_size_read  = 64;
         3'b111:burst_size_read  = 128;             
     endcase
     case (AXI_AWSIZE) 
         3'b000:burst_size_write = 1;
         3'b001:burst_size_write = 2;
         3'b010:burst_size_write = 4;
         3'b011:burst_size_write = 8;
         3'b100:burst_size_write = 16;
         3'b101:burst_size_write = 32;
         3'b110:burst_size_write = 64;
         3'b111:burst_size_write = 128;             
     endcase
end

//to determine the type of read burst 

always @(mem_read_status,mem_write_status , burstCounter)
  begin 

    if(mem_read_status) 
      begin 
          if ( AXI_ARBURST_r == `FIXED ) 
              addr <= AXI_ARADDR_r  ;
                else if (AXI_ARBURST_r == `INCR)
                    addr <= AXI_ARADDR_r + burst_size_read * burstCounter;
      end          
    if(mem_write_status) 
      begin
          if ( AXI_AWBURST_r == `FIXED ) 
              addr <= AXI_AWADDR_r  ;
            else if (AXI_AWBURST_r == `INCR) 
                addr <= AXI_AWADDR_r + burst_size_write * burstCounter;
      end
  end 

assign we =  (AXI_WVALID & AXI_WREADY);
assign en = (we | mem_read_status);
assign be = AXI_WSTRB;


endmodule

`endprotect

