//----------------------------------------------------------------------
// COPYRIGHT (C) 2016 SYNOPSYS INC.
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

module AXI_SLAVE_DUT(
// Global inputs
   ACLK,
   ARESETn,

// Write Address Channel
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
   AXI_WDATA,
   AXI_WSTRB,
   AXI_WLAST,
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
   AXI_RDATA,
   AXI_RRESP,
   AXI_RLAST,
   AXI_RVALID,
   AXI_RREADY,

// Slave -> Master USER Signals
   AXI_BUSER,
   AXI_RUSER

);


parameter DATA_WRITE_WIDTH    = 64;
parameter DATA_READ_WIDTH     = 64;
parameter ID_WIDTH            = 16;
parameter WSTRB_WIDTH         = DATA_WRITE_WIDTH/8;

// Global signals
input         ACLK;                       // AXI Clock
input         ARESETn;                    // AXI Reset

input  [ID_WIDTH-1:0]  AXI_AWID;                     // write addressID
input  [31:0]          AXI_AWADDR;                   // write address
input  [7:0]           AXI_AWLEN;                    // write burst length
input  [2:0]           AXI_AWSIZE;                   // write burst size
input  [1:0]           AXI_AWBURST;                  // write burst type
input                  AXI_AWLOCK;                   // write lock type
input  [3:0]           AXI_AWCACHE;                  // write cache type
input  [2:0]           AXI_AWPROT;                   // write protection level
input                  AXI_AWVALID;                  // write address valid
output                 AXI_AWREADY;                  // address ready

input  [DATA_WRITE_WIDTH-1:0] AXI_WDATA;                    // write data
input  [WSTRB_WIDTH-1:0]  AXI_WSTRB;                    // write strobes
input         AXI_WLAST;                    // write last
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
input         AXI_ARLOCK;                   // read lock type
input  [3:0]  AXI_ARCACHE;                  // read cache type
input  [2:0]  AXI_ARPROT;                   // read protection level
input         AXI_ARVALID;                  // read address valid
output        AXI_ARREADY;                  // read address ready


output [ID_WIDTH-1:0]  AXI_RID;                      // read id
output [DATA_READ_WIDTH-1:0] AXI_RDATA;                    // read data
output [1:0]  AXI_RRESP;                    // read response
output        AXI_RLAST;                    // read last
output        AXI_RVALID;                   // read valid
input         AXI_RREADY;                   // read ready

// Slave -> Master USER Signals

output reg [`USER_WIDTH_MACRO -1:0] AXI_BUSER;
output reg [`USER_WIDTH_MACRO -1:0] AXI_RUSER;

// USER signals generation (Slave->Master)

reg [63:0] buser_data;

initial begin
buser_data = 7 ;
end

always@(posedge ACLK) begin
   buser_data <= buser_data * 13 ;
   AXI_BUSER  <= buser_data;
   AXI_RUSER  <= buser_data + 1  ;
end
wire [31:0] addr;
wire en;
wire we;
wire [WSTRB_WIDTH-1:0] be;

reg [3:0] resetcnt;

// -----------------------------------------------------------------------------
// Instantiation of AXI Block RAMs
// -----------------------------------------------------------------------------
AXI_SLAVE_MEMORY_CTRL  #(.DATA_WIDTH(DATA_WRITE_WIDTH), .ID_WIDTH(ID_WIDTH), .WREADY_DELAY(0)) axictrl0(
  .ACLK               (ACLK),
  .ARESETn            (ARESETn),
  .AXI_AWID           (AXI_AWID),
  .AXI_AWADDR         (AXI_AWADDR),
  .AXI_AWLEN          (AXI_AWLEN[7:0]),
  .AXI_AWSIZE         (AXI_AWSIZE),
  .AXI_AWBURST        (AXI_AWBURST),
  .AXI_AWLOCK         (AXI_AWLOCK),
  .AXI_AWCACHE        (AXI_AWCACHE),
  .AXI_AWPROT         (AXI_AWPROT),
  .AXI_AWVALID        (AXI_AWVALID),
  .AXI_AWREADY        (AXI_AWREADY),
  .AXI_WLAST          (AXI_WLAST),
  .AXI_WSTRB          (AXI_WSTRB),
  .AXI_WVALID         (AXI_WVALID),
  .AXI_WREADY         (AXI_WREADY),
  .AXI_BID            (AXI_BID),
  .AXI_BRESP          (AXI_BRESP),
  .AXI_BVALID         (AXI_BVALID),
  .AXI_BREADY         (AXI_BREADY),
  .AXI_ARID           (AXI_ARID),
  .AXI_ARADDR         (AXI_ARADDR),
  .AXI_ARLEN          (AXI_ARLEN[7:0]),
  .AXI_ARSIZE         (AXI_ARSIZE),
  .AXI_ARBURST        (AXI_ARBURST),
  .AXI_ARLOCK         (AXI_ARLOCK),
  .AXI_ARCACHE        (AXI_ARCACHE),
  .AXI_ARPROT         (AXI_ARPROT),
  .AXI_ARVALID        (AXI_ARVALID),
  .AXI_ARREADY        (AXI_ARREADY),
  .AXI_RID            (AXI_RID),
  .AXI_RRESP          (AXI_RRESP),
  .AXI_RLAST          (AXI_RLAST),
  .AXI_RVALID         (AXI_RVALID),
  .AXI_RREADY         (AXI_RREADY),
  .en                 (en),
  .we                 (we),
  .addr               (addr),
  .be                 (be)
);

 zebu_sram2Mx #(DATA_WRITE_WIDTH) uRAM0 (
  .CLK              (ACLK),
  .ME               (en),
  .ADDR             (addr[20:0]), //Addr for complete word is generated for single cycle only
  //.ADDR             (addr[22:2]),
  .DI               (AXI_WDATA[DATA_WRITE_WIDTH-1:0]),
  .WE               (we),
  .BW               (be[WSTRB_WIDTH-1:0]),
  .DO               (AXI_RDATA[DATA_WRITE_WIDTH-1:0])
);

endmodule
