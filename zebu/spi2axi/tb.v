`timescale 1ns/1ps
module tb();
    reg            sclk              ;    // System Clock.
    reg            srstn             ;    // System Reset. Low Active 
    reg  [ 7 : 0]  sclk_divider      ;    // SPI Clock Control 
    reg            wr_start          ;    // ReRAM Write  Start 
    reg            rd_start          ;    // ReRAM Read   Start  

    wire           wr_finish         ;    // ReRAM Write  Finish 
    wire           rd_finish         ;    // ReRAM Read   Finish

    reg   [ 7 : 0] start_addr        ;    // Write / Read Start Address
    reg   [ 7 : 0] state_init        ; 

    reg   [ 7 : 0] rx_rd_data        ;    // Rx BRAM Read Data
    wire  [ 7 : 0] tx_wr_data        ;    // Tx BRAM Write Data

    wire           SPI_SCLK          ;   // Reram SPI Clock 
    wire           SPI_CSN           ;    // ReRAM SPI Chip Select 
    wire           SPI_MOSI          ;    // ReRAM SPI Master Output 
    reg            SPI_MISO          ;    // ReRAM SPI Master Input
    
  //==============================================================
// initial  value
//==============================================================
    initial begin
    
        sclk         = 1'b0 ;
        SPI_MISO     = 1'b0 ;
        
        srstn        = 1'b0 ;
        rd_start     = 1'b0 ;
        wr_start     = 1'b0 ;
        start_addr   = 8'h0 ;
        rx_rd_data   = 8'h0 ;
        sclk_divider = 8'h0 ;
        #100
        srstn        = 1'b1 ;
        #150
        rx_rd_data   = 8'haa;
        rd_start     = 1'b0 ;
        wr_start     = 1'b1 ;
        start_addr   = 8'h55;
        state_init   = 8'haf;
        sclk_divider = 8'h1 ;
        #200
        rd_start     = 1'b0 ;
        wr_start     = 1'b0 ;
       // $monitor  (" r_tx_bram_wr_data:%h", r_tx_wr_data);
    end
        always #50    sclk     = ~sclk      ; 
    `ifdef COEMU
    //for FWC generation
    initial begin: dump_hw_top
        (* fwc *) $dumpvars  (0, tb);//Dump all ports of an instance 
    end
`endif

endmodule