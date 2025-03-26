`timescale 1 ns / 1 ps 
`define DATA_WIDTH       32 
`define ADDR_WIDTH       40
`define ID_WIDTH         1
`define WSTRB_WIDTH      `DATA_WIDTH >> 3
`define BLEN_WIDTH       5
`define XTOR_DEBUG_WIDTH 10
`define USER_WIDTH_MACRO 64

module SPI_Master_WRAPPER(
    input   wire           sclk               ,    // System Clock.
    input   wire           srstn              ,    // System Reset. Low Active 
    //====== Control / Status ======================
    input   wire  [ 7 : 0] sclk_divider       ,    // SPI Clock Control / Divid
    //====== Control / Status ======================
    input   wire           wr_start           ,    // Write  Start 
    input   wire           rd_start           ,    // Read   Start  

    output  wire           wr_finish          ,    // Write  Finish 
    output  wire           rd_finish          ,    // Read   Finish

    input   wire  [ 7 : 0] start_addr         ,    // Write / Read Start Address
    input   wire  [ 7 : 0] state_init         ,    // slaver state initial  
    //====== Rx Interface =========================
    input   wire  [ 7 : 0] rx_rd_data         ,    // Rx Read Data
    //====== Tx Interface =====================
    output  wire  [ 7 : 0] tx_wr_data         
 );
 
  //  always #400   SPI_MISO = ~SPI_MISO  ; 

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
   SPI_Master SPI_Master_init (
    .sclk        (sclk        ),    // System Clock.
    .srstn       (srstn       ),    // System Reset. Low Active 
    .sclk_divider(sclk_divider),    // SPI Clock Control / Divid
    .wr_start    (wr_start    ),    // Write  Start 
    .rd_start    (rd_start    ),    // Read   Start  

    .wr_finish   (wr_finish   ),    // Write  Finish 
    .rd_finish   (rd_finish   ),    // Read   Finish

    .start_addr  (start_addr  ),    // Write / Read Start Address
    .state_init  (state_init  ),    // slaver state initial  
    .rx_rd_data  (rx_rd_data  ),    // Rx Read Data
    .tx_wr_data  (tx_wr_data  ),    // Tx Write Data

    .SPI_SCLK    (SPI_SCLK    ),    // SPI Clock 
    .SPI_CSN     (SPI_CSN     ),    // SPI Chip Select 
    .SPI_MOSI    (SPI_MOSI    ),    // SPI Master Output 
    .SPI_MISO    (SPI_MISO[0]    )     // SPI Master Input
); 

spi2axi_top u0_spi2axi_top(/*autoinst*/
        .sclk                                 (SPI_SCLK),// input 
        .csn                                  (SPI_CSN),// input 
        .mosi                                 ({3'b000,SPI_MOSI}),// input 
        .miso                                 (SPI_MISO),// output
        .spi_dat_pad_oe                       (),// output
        .spi_dat_pad_ie                       (),// output
        .ptest_scan_mode                      (1'b0),// input 
        .rst_scan_n                           (1'b1),// input 
    //axi clock and reset
        .aclk                                 (sclk),// input 
        .aresetn                              (srstn),// input 
    //write address channel
        .awid                                 (AXI_AWID),// output
        .awaddr                               (AXI_AWADDR),// output
        .awlen                                (AXI_AWLEN[4:0]),// output
        .awsize                               (AXI_AWSIZE[1:0]),// output
        .awburst                              (AXI_AWBURST[1:0]),// output
        .awlock                               (),// output
        .awcache                              (AXI_AWCACHE[3:0]),// output
        .awprot                               (AXI_AWPROT),// output
        .awvalid                              (AXI_AWVALID),// output
        .awready                              (AXI_AWREADY),// input 

    //write data channel
        .wdata                                (AXI_WDATA[31:0]),// output
        .wstrb                                (AXI_WSTRB[3:0]),// output
        .wlast                                (AXI_WLAST),// output
        .wvalid                               (AXI_WVALID),// output
        .wready                               (AXI_WREADY),// input 

    //write response channel
        .bid                                  (AXI_BID),// input 
        .bresp                                (AXI_BRESP[1:0]),// input 
        .bvalid                               (AXI_BVALID),// input 
        .bready                               (AXI_BREADY),// output

    //read address channel
        .arid                                 (AXI_ARID),// output
        .araddr                               (AXI_ARADDR),// output
        .arlen                                (AXI_ARLEN[4:0]),// output
        .arsize                               (AXI_ARSIZE[1:0]),// output
        .arburst                              (AXI_ARBURST[1:0]),// output
        .arlock                               (),// output
        .arcache                              (AXI_ARCACHE[3:0]),// output
        .arprot                               (AXI_ARPROT[2:0]),// output
        .arvalid                              (AXI_ARVALID),// output
        .arready                              (AXI_ARREADY),// input 

    //read data channel
        .rid                                  (AXI_RID),// input 
        .rdata                                (AXI_RDATA[31:0]),// input 
        .rresp                                (AXI_RRESP[1:0]),// input 
        .rvalid                               (AXI_RVALID),// input 
        .rready                               (AXI_RREADY),// output
        .rlast                                (AXI_RLAST),// input 

        .rf_cfg_register0                     (),// output
        .rf_cfg_register1                     (),// output
        .rf_cfg_register2                     (),// output
        .rf_cfg_register3                     (),// output
        .rx_fifo_full_w_flag                  (),// output
        .chip_status0                         (32'h0/*chip_status0[31:0]*/),// input 
        .chip_status1                         (32'h0/*chip_status1[31:0]*/),// input 
        .chip_status2                         (32'h0/*chip_status2[31:0]*/),// input 
        .chip_status3                         (32'h0/*chip_status3[31:0]*/)// input 
);
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
                                .ARESETn(srstn),
                                .ACLK(sclk));


endmodule
