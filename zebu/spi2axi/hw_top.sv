
`define DATA_WIDTH       32 
`define ADDR_WIDTH       40
`define ID_WIDTH         1
`define WSTRB_WIDTH      `DATA_WIDTH >> 3
`define BLEN_WIDTH       5
`define XTOR_DEBUG_WIDTH 10
`define USER_WIDTH_MACRO 64

module hw_top();

// Parameter Declaration
parameter CLOCK_PERIOD         = 20;
parameter RST_PERIOD           = 1000;

parameter DATA_WIDTH           = `DATA_WIDTH  ;
parameter ADDR_WIDTH           = `ADDR_WIDTH  ;
parameter ID_WIDTH             = `ID_WIDTH    ; 
parameter WSTRB_WIDTH          = `WSTRB_WIDTH ;
parameter BLEN_WIDTH           = `BLEN_WIDTH  ;
parameter USER_WIDTH           = `USER_WIDTH_MACRO;
parameter XTOR_DEBUG_WIDTH     = `XTOR_DEBUG_WIDTH;
parameter AXI_INTERLEAVE_DEPTH = 1;

// AXI Bus Signals

// Write Data Channel 
wire  [DATA_WIDTH-1:0]     AXI_WDATA;
wire  [ID_WIDTH-1:0]       AXI_WID;
wire  [WSTRB_WIDTH-1:0]    AXI_WSTRB;
wire                       AXI_WLAST;
wire                       AXI_WVALID;
wire                       AXI_WREADY;

// Write Addr Channel
wire  [ADDR_WIDTH-1:0]     AXI_AWADDR;
wire  [ID_WIDTH-1:0]       AXI_AWID;
wire  [BLEN_WIDTH-1:0]                AXI_AWLEN;
wire  [2:0]                AXI_AWSIZE;
wire  [2:0]                AXI_AWPROT;
wire  [1:0]                AXI_AWBURST;
wire  [3:0]                AXI_AWCACHE;
wire                       AXI_AWVALID;
wire                       AXI_AWREADY;
wire                       AXI_AWLOCK;
// Write Resp channel
wire  [ID_WIDTH-1:0]       AXI_BID;
wire  [1:0]                AXI_BRESP;
wire                       AXI_BVALID;
wire                       AXI_BREADY;

// Read Addr Channel
wire  [ADDR_WIDTH-1:0]     AXI_ARADDR;
wire  [ID_WIDTH-1:0]       AXI_ARID;
wire  [BLEN_WIDTH-1:0]     AXI_ARLEN;
wire  [2:0]                AXI_ARSIZE;
wire  [2:0]                AXI_ARPROT;
wire  [1:0]                AXI_ARBURST;
wire  [3:0]                AXI_ARCACHE;
wire                       AXI_ARVALID;
wire                       AXI_ARREADY;

// Read Resp Channel
wire  [DATA_WIDTH-1:0]     AXI_RDATA;
wire  [ID_WIDTH-1:0]       AXI_RID;
wire  [1:0]                AXI_RRESP;
wire                       AXI_RLAST;
wire                       AXI_RVALID;
wire                       AXI_RREADY;
wire                       AXI_ARLOCK;


// AXI4 signals
wire  [USER_WIDTH-1:0]     AXI_BUSER; 
wire  [USER_WIDTH-1:0]     AXI_RUSER; 
wire [3:0]                 AXI_AWQOS;
wire [3:0]                 AXI_ARQOS;
wire [3:0]                 AXI_AWREGION;
wire [3:0]                 AXI_ARREGION;
wire [USER_WIDTH-1:0]      AXI_AWUSER;
wire [USER_WIDTH-1:0]      AXI_ARUSER;
wire [USER_WIDTH-1:0]      AXI_WUSER;
wire [USER_WIDTH-1:0]      AXI_RUSER;
wire [USER_WIDTH-1:0]      AXI_BUSER;


// Clock and reset handling
    reg                        reset;
    reg                    clk_local;
    always begin
        forever #(CLOCK_PERIOD/2) 
            clk_local = ~clk_local;
    end
    
    initial
    begin
        reset                        = 0;
        #RST_PERIOD;     
        reset                        = 1;
    end
`ifndef SIMXL
    initial
        clk_local                    = 0;
`endif


AXI_SLAVE_DUT                #(
                                  .DATA_WRITE_WIDTH(DATA_WIDTH),
                                  .DATA_READ_WIDTH(DATA_WIDTH),  
                                  .ID_WIDTH(ID_WIDTH),       
                                  .WSTRB_WIDTH(WSTRB_WIDTH)
                              )

         dut(
                                .AXI_WDATA(AXI_WDATA),  
                                .AXI_WSTRB(AXI_WSTRB), 
                                .AXI_WLAST(AXI_WLAST),
                                .AXI_WVALID(AXI_WVALID),
                                .AXI_WREADY(AXI_WREADY),
                                .AXI_AWADDR(AXI_AWADDR),
                                .AXI_AWID(AXI_AWID),
                                .AXI_AWLEN(AXI_AWLEN),
                                .AXI_AWSIZE(AXI_AWSIZE),
                                .AXI_AWPROT(AXI_AWPROT),
                                .AXI_AWBURST(AXI_AWBURST), 
                                .AXI_AWCACHE(AXI_AWCACHE),
                                .AXI_AWVALID(AXI_AWVALID), 
                                .AXI_AWREADY(AXI_AWREADY),
                                .AXI_BID(AXI_BID),
                                .AXI_BRESP(AXI_BRESP), 
                                .AXI_BVALID(AXI_BVALID), 
                                .AXI_BREADY(AXI_BREADY),
                                .AXI_ARADDR(AXI_ARADDR),
                                .AXI_ARID(AXI_ARID),
                                .AXI_ARLEN(AXI_ARLEN),
                                .AXI_ARSIZE(AXI_ARSIZE),
                                .AXI_ARPROT(AXI_ARPROT), 
                                .AXI_ARBURST(AXI_ARBURST), 
                                .AXI_ARCACHE(AXI_ARCACHE),
                                .AXI_ARVALID(AXI_ARVALID),
                                .AXI_ARREADY(AXI_ARREADY),
                                .AXI_RDATA(AXI_RDATA), 
                                .AXI_RID(AXI_RID),
                                .AXI_RRESP(AXI_RRESP),
                                .AXI_RLAST(AXI_RLAST),
                                .AXI_RVALID(AXI_RVALID),
                                .AXI_RREADY(AXI_RREADY),
                                .AXI_BUSER(AXI_BUSER),
                                .AXI_RUSER(AXI_RUSER),
                                .ARESETn(reset),
                                .ACLK(clk_local));

`ifdef COEMU
    //for FWC generation
    initial begin: dump_hw_top
        (* fwc *) $dumpvars  (0, hw_top);//Dump all ports of an instance 
    end
`endif

endmodule
