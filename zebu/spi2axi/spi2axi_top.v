// +FHDR------------------------------------------------------------
//                 Copyright (c) 2019 COMPANY: Undefined variable..
//                       ALL RIGHTS RESERVED
// -----------------------------------------------------------------
// Filename      : spi2axi_top.v
// Author        : yinxiaofu
// Created On    : 2019-07-27 17:53
// Last Modified : 2023-01-12 19:00
// -----------------------------------------------------------------
// Description:
//
//
// -FHDR------------------------------------------------------------

//`ifndef __SPI2AHB_V__
//`define __SPI2AHB_V__

//`timescale 1ns/1ps

module spi2axi_top(/*autoarg*/
    //Inputs
    sclk, csn, mosi, ptest_scan_mode, rst_scan_n, 
    aclk, aresetn, awready, wready, bid, bresp,
    bvalid, arready, rid, rdata, rresp, rlast,
    rvalid,
    chip_status0, chip_status1, chip_status2, 
    chip_status3, 

    //Outputs
    miso, spi_dat_pad_oe, spi_dat_pad_ie, 
    awid, awaddr, awlen, awsize, awburst,awlock,
    awcache, awprot, awvalid,  wdata, wstrb,
    wlast, wvalid, arid, araddr, arlen, arsize,
    arburst, arlock, arcache, arprot, arvalid,
    bready,rready, rf_cfg_register0, 
    rf_cfg_register1, rf_cfg_register2, rf_cfg_register3,
    rx_fifo_full_w_flag
);

input                                   sclk             ;   // from pad spi clk
input                                   csn              ;   // from pad csn
input        [3:0]                      mosi             ;   // from pad spi data
output       [3:0]                      miso             ;   // to   pad spi data
output       [3:0]                      spi_dat_pad_oe   ;   // to   pad spi data oen
output       [3:0]                      spi_dat_pad_ie   ;   // not use 

input                                   ptest_scan_mode  ;
input                                   rst_scan_n       ;

//axi clock and reset
input                                   aclk             ;
input                                   aresetn          ;

//write address channel
output                                  awid             ;
output       [39:0]                     awaddr           ;
output       [4:0]                      awlen            ;
output       [1:0]                      awsize           ;
output       [1:0]                      awburst          ;
output                                  awlock           ;
output       [3:0]                      awcache          ;
output       [2:0]                      awprot           ;
output                                  awvalid          ;
input                                   awready          ;

//write data channel
output       [31:0]                     wdata            ;
output       [3:0]                      wstrb            ;
output                                  wlast            ;
output                                  wvalid           ;
input                                   wready           ;

//write response channel
input                                   bid              ;
input        [1:0]                      bresp            ;
input                                   bvalid           ;
output                                  bready           ;

//read address channel
output                                  arid             ;
output       [39:0]                     araddr           ;
output       [4:0]                      arlen            ;
output       [1:0]                      arsize           ;
output       [1:0]                      arburst          ;
output                                  arlock           ;
output       [3:0]                      arcache          ;
output       [2:0]                      arprot           ;
output                                  arvalid          ;
input                                   arready          ;

//read data channel
input                                   rid              ;
input        [31:0]                     rdata            ;
input        [1:0]                      rresp            ;
input                                   rlast            ;
input                                   rvalid           ;
output                                  rready           ;



output       [31:0]                     rf_cfg_register0 ;   // only use bit[0] for ptest_func_cpu_resetn
output       [31:0]                     rf_cfg_register1 ;   // not use
output       [31:0]                     rf_cfg_register2 ;   // not use
output       [31:0]                     rf_cfg_register3 ;
output                                  rx_fifo_full_w_flag ;
input        [31:0]                     chip_status0     ;   // tie 32'h0
input        [31:0]                     chip_status1     ;   // tie 32'h0
input        [31:0]                     chip_status2     ;   // tie 32'h0
input        [31:0]                     chip_status3     ;   // tie 32'h0

//{{{
/*autodef*/
// Define flip-flop registers here
// Define combination registers here
// Define wires here
wire          rst_n;    //
// Define instances' ouput wires here
// End of automatic define
wire [31:0]             addr_info_debug;        
wire [39:0]             axi_acc_addr;           
wire [15:0]             axi_acc_len;            
wire [2:0]              axi_acc_size;            
wire                    axi_acc_start;          
wire                    axi_acc_write;          
wire [15:0]             ahb_count;              
wire [15:0]             ahb_len;                
wire                    ahb_write;              
wire                    clk_reg;                
wire                    clk_rx_fifo;            
wire                    clk_tx_fifo;            
wire [31:0]             ctrl_info_debug;        
wire [31:0]             reg_addr;               
wire                    reg_rd_en;              
wire [31:0]             reg_rdata;              
wire [31:0]             reg_wdata;              
wire                    reg_wr_en;              
wire [15:0]             rf_wait_symbol_num;     
wire                    rx_fifo_ae_r;           
wire                    rx_fifo_ae_w;           
wire                    rx_fifo_af_r;           
wire                    rx_fifo_af_w;           
wire                    rx_fifo_empty_r;        
wire                    rx_fifo_empty_w;        
wire [3:0]              rx_fifo_filled_depth_r; 
wire [3:0]              rx_fifo_filled_depth_w; 
wire                    rx_fifo_full_r;         
wire                    rx_fifo_full_w;         
wire [3:0]              rx_fifo_raddr_r;        
wire [3:0]              rx_fifo_raddr_w;        
wire                    rx_fifo_rd_en;          
wire [31:0]             rx_fifo_rdata;          
wire [3:0]              rx_fifo_waddr_r;        
wire [3:0]              rx_fifo_waddr_w;        
wire [31:0]             rx_fifo_wdata;          
wire                    rx_fifo_wr_en;          
wire                    tx_fifo_ae_r;           
wire                    tx_fifo_ae_w;           
wire                    tx_fifo_af_r;           
wire                    tx_fifo_af_w;           
wire                    tx_fifo_empty_r;        
wire                    tx_fifo_empty_w;        
wire [3:0]              tx_fifo_filled_depth_r; 
wire [3:0]              tx_fifo_filled_depth_w; 
wire                    tx_fifo_full_r;         
wire                    tx_fifo_full_w;         
wire [3:0]              tx_fifo_raddr_r;        
wire [3:0]              tx_fifo_raddr_w;        
wire                    tx_fifo_rd_en;          
wire [31:0]             tx_fifo_rdata;          
wire [3:0]              tx_fifo_waddr_r;        
wire [3:0]              tx_fifo_waddr_w;        
wire [31:0]             tx_fifo_wdata;          
wire                    tx_fifo_wr_en;          
/*autowire*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
// End of automatics
/*autoreg*/
//}}}

wire   [31:0]   spi_frame_ctrl_info ;
wire   [39:0]   spi_frame_addr_info ;
wire   [2:0]   spi_cur_st ;
wire   [15:0]  axi_count;
wire   [15:0]  axi_len;
wire           axi_write;

/* spi2axi_rf  auto_template ( 
  ); */
spi2axi_rf 
         u0_spi2axi_rf(/*autoinst*/
                       // Outputs
        .reg_rdata            (reg_rdata[31:0]                                              ),
        .rf_cfg_register0     (rf_cfg_register0[31:0]                                       ),
        .rf_cfg_register1     (rf_cfg_register1[31:0]                                       ),
        .rf_cfg_register2     (rf_cfg_register2[31:0]                                       ),
        .rf_cfg_register3     (rf_cfg_register3[31:0]                                       ),
        .rf_ahb_prot          (                                                             ),
        .rf_wait_symbol_num   (rf_wait_symbol_num[15:0]                                     ),
        .rx_fifo_full_w_flag  (rx_fifo_full_w_flag                                          ),

                       // Inputs
        .sclk                 (clk_reg                                                      ),
        .rst_n                (aresetn                                                      ),
        .reg_wr_en            (reg_wr_en                                                    ),
        .reg_rd_en            (reg_rd_en                                                    ),
        .reg_addr             (reg_addr[31:0]                                               ),
        .reg_wdata            (reg_wdata[31:0]                                              ),
        .spi_frame_ctrl_info  (spi_frame_ctrl_info[31:0]                                    ),
        .spi_frame_addr_info  (spi_frame_addr_info[31:0]                                    ),
        .spi_cur_st           (spi_cur_st[1:0]                                              ),
        .ahb_cur_st           (2'b00                                                        ),
        .ahb_write            (axi_write                                                    ),
        .hready_sts           (1'b1                                                         ),
        .hresp_err            (1'b0                                                         ),
        .htrans_sts           (2'b00                                                        ),
        .ahb_count            (axi_count[15:0]                                              ),
        .ahb_len              (axi_len[15:0]                                                ),
        .rx_fifo_empty_r      (rx_fifo_empty_r                                              ),  // record fifo full empty pointer
        .rx_fifo_full_w       (rx_fifo_full_w                                               ),
        .rx_fifo_depth        (rx_fifo_filled_depth_r[3:0]                                  ),
        .rx_fifo_raddr_r      (rx_fifo_raddr_r[2:0]                                         ),
        .rx_fifo_waddr_w      (rx_fifo_waddr_w[2:0]                                         ),
        .tx_fifo_empty_r      (tx_fifo_empty_r                                              ),
        .tx_fifo_full_w       (tx_fifo_full_w                                               ),
        .tx_fifo_depth        (tx_fifo_filled_depth_w[3:0]                                  ),
        .tx_fifo_raddr_r      (tx_fifo_raddr_r[2:0]                                         ),
        .tx_fifo_waddr_w      (tx_fifo_waddr_w[2:0]                                         ),
        .chip_dbg_status0     (chip_status0[31:0]                                           ),
        .chip_dbg_status1     (chip_status1[31:0]                                           ),
        .chip_dbg_status2     (chip_status2[31:0]                                           ),
        .chip_dbg_status3     (chip_status3[31:0]                                           ));

assign rst_n = ptest_scan_mode ? rst_scan_n : (~csn) & aresetn ;

/* spi2axi_spi_slv  auto_template ( 
  ); */
spi2axi_spi_slv 
         u0_spi2axi_spi_slv(/*autoinst*/
                            // Outputs
        .miso                 (miso[3:0]                                                    ),
        .spi_dat_pad_oe       (spi_dat_pad_oe[3:0]                                          ),
        .spi_dat_pad_ie       (spi_dat_pad_ie[3:0]                                          ),
        .clk_rx_fifo          (clk_rx_fifo                                                  ),
        .rx_fifo_wr_en        (rx_fifo_wr_en                                                ),
        .rx_fifo_wdata        (rx_fifo_wdata[31:0]                                          ),
        .clk_tx_fifo          (clk_tx_fifo                                                  ),
        .tx_fifo_rd_en        (tx_fifo_rd_en                                                ),
        .ahb_acc_start        (axi_acc_start                                                ),
        .ahb_acc_write        (axi_acc_write                                                ),
        .ahb_acc_addr         (axi_acc_addr                                           ),
        .ahb_acc_len          (axi_acc_len                                            ),
        .ahb_acc_size         (axi_acc_size                                            ),
        .clk_reg              (clk_reg                                                      ),
        .reg_wr_en            (reg_wr_en                                                    ),
        .reg_rd_en            (reg_rd_en                                                    ),
        .reg_addr             (reg_addr[31:0]                                               ),
        .reg_wdata            (reg_wdata[31:0]                                              ),
        .ctrl_info_debug      (spi_frame_ctrl_info[31:0]                                    ),
        .addr_info_debug      (spi_frame_addr_info[39:0]                                    ),
        .cur_st               (spi_cur_st[2:0]                                              ),
                            // Inputs
        .sclk                 (sclk                                                         ),
        .csn                  (csn                                                          ),
        .mosi                 (mosi[3:0]                                                    ),
        .rst_n                (rst_n                                                        ),
        .hresetn              (aresetn                                                      ),
        .rf_wait_symbol       (rf_wait_symbol_num[15:0]                                     ),
        .tx_fifo_rdata        (tx_fifo_rdata[31:0]                                          ),
        .reg_rdata            (reg_rdata[31:0]                                              ));



spi2axi_axi_mst 
         u0_spi2axi_axi_mst(/*autoinst*/
.aclk                       (aclk                        ),                              
.aresetn                    (aresetn                     ),           
.awid                       (awid                        ),           
.awaddr                     (awaddr                      ),           
.awlen                      (awlen                       ),           
.awsize                     (awsize                      ),           
.awburst                    (awburst                     ),           
.awlock                     (awlock                      ),           
.awcache                    (awcache                     ),           
.awprot                     (awprot                      ),           
.awvalid                    (awvalid                     ),           
.awready                    (awready                     ),                              

.wdata                      (wdata                       ),          
.wstrb                      (wstrb                       ),          
.wlast                      (wlast                       ),          
.wvalid                     (wvalid                      ),          
.wready                     (wready                      ),          
                                   
.bid                        (bid                         ),          
.bresp                      (bresp                       ),          
.bvalid                     (bvalid                      ),          
.bready                     (bready                      ),          
                                   
.arid                       (arid                        ),           
.araddr                     (araddr                      ),           
.arlen                      (arlen                       ),           
.arsize                     (arsize                      ),           
.arburst                    (arburst                     ),           
.arlock                     (arlock                      ),           
.arcache                    (arcache                     ),           
.arprot                     (arprot                      ),           
.arvalid                    (arvalid                     ),           
.arready                    (arready                     ),           

.rid                        (rid                         ),          
.rdata                      (rdata                       ),          
.rresp                      (rresp                       ),          
.rlast                      (rlast                       ),          
.rvalid                     (rvalid                      ),          
.rready                     (rready                      ),          
                                          
.sclk                       (sclk                        ),         
.rst_n                      (rst_n                       ),         
                                          
.axi_acc_start              (axi_acc_start               ),                 
.axi_acc_write              (axi_acc_write               ),                 
.axi_acc_addr               (axi_acc_addr                ),                 
.axi_acc_len                (axi_acc_len                 ),                 
.axi_acc_size               (axi_acc_size                ),                 
                                         
.rx_fifo_empty              (rx_fifo_empty_r             ),                 
.rx_fifo_rd_en              (rx_fifo_rd_en               ),                 
.rx_fifo_rdata              (rx_fifo_rdata[31:0]         ),                 
.tx_fifo_full               (tx_fifo_af_w                ),                 
.tx_fifo_wr_en              (tx_fifo_wr_en               ),                 
.tx_fifo_wdata              (tx_fifo_wdata[31:0]         ),                 
                                          
.w_count                    (axi_count[15:0]             ),             
.axi_len                    (axi_len[15:0]               ),             
.axi_write                  (axi_write                   ));    
/* spi2axi_afifo_regfile  auto_template ( 
        .fifo_\(.*\)          (rx_fifo_\1[]                                                                                 
        .ADDR_WIDTH           (3                                                            ),
        .DATA_WIDTH           (32                                                           ),
  ); */
spi2axi_afifo_regfile #(/*autoinstparam*/
                // Parameters
        .ADDR_WIDTH           (3                                                            ),//Templated
        .DATA_WIDTH           (32                                                           ))// Templated
         u_rx_fifo(/*autoinst*/
                   // Outputs
        .fifo_rdata           (rx_fifo_rdata[31:0]                                          ),//Templated
        .fifo_af_w            (rx_fifo_af_w                                                 ),//Templated
        .fifo_af_r            (rx_fifo_af_r                                                 ),//Templated
        .fifo_ae_w            (rx_fifo_ae_w                                                 ),//Templated
        .fifo_ae_r            (rx_fifo_ae_r                                                 ),//Templated
        .fifo_full_w          (rx_fifo_full_w                                               ),//Templated
        .fifo_full_r          (rx_fifo_full_r                                               ),//Templated
        .fifo_empty_w         (rx_fifo_empty_w                                              ),//Templated
        .fifo_empty_r         (rx_fifo_empty_r                                              ),//Templated
        .fifo_filled_depth_w  (rx_fifo_filled_depth_w[3:0]                                  ),//Templated
        .fifo_filled_depth_r  (rx_fifo_filled_depth_r[3:0]                                  ),//Templated
        .fifo_waddr_w         (rx_fifo_waddr_w[3:0]                                         ),//Templated
        .fifo_waddr_r         (rx_fifo_waddr_r[3:0]                                         ),//Templated
        .fifo_raddr_w         (rx_fifo_raddr_w[3:0]                                         ),//Templated
        .fifo_raddr_r         (rx_fifo_raddr_r[3:0]                                         ),//Templated
                   // Inputs
        .clk_fifo_w           (clk_rx_fifo                                                  ),
        .rst_fifo_w_n         (aresetn                                                      ),
        .clk_fifo_r           (aclk                                                         ),
        .rst_fifo_r_n         (aresetn                                                      ),
        .fifo_af_lvl_w        (3'd6                                                         ),//Templated
        .fifo_af_lvl_r        (3'd6                                                         ),//Templated
        .fifo_ae_lvl_w        (3'd2                                                         ),//Templated
        .fifo_ae_lvl_r        (3'd2                                                         ),//Templated
        .fifo_wr_en           (rx_fifo_wr_en                                                ),//Templated
        .fifo_wdata           (rx_fifo_wdata[31:0]                                          ),//Templated
        .fifo_rd_en           (rx_fifo_rd_en                                                ));// Templated

/* spi2axi_afifo_regfile  auto_template ( 
        .fifo_\(.*\)          (tx_fifo_\1[]                                                 ),
        .ADDR_WIDTH           (3                                                            ),
        .DATA_WIDTH           (32                                                           ),
  ); */
spi2axi_afifo_regfile #(/*autoinstparam*/
                // Parameters
        .ADDR_WIDTH           (3                                                            ),//Templated
        .DATA_WIDTH           (32                                                           ))// Templated
         u_tx_fifo(/*autoinst*/
                          // Outputs
        .fifo_rdata           (tx_fifo_rdata[31:0]                                          ),//Templated
        .fifo_af_w            (tx_fifo_af_w                                                 ),//Templated
        .fifo_af_r            (tx_fifo_af_r                                                 ),//Templated
        .fifo_ae_w            (tx_fifo_ae_w                                                 ),//Templated
        .fifo_ae_r            (tx_fifo_ae_r                                                 ),//Templated
        .fifo_full_w          (tx_fifo_full_w                                               ),//Templated
        .fifo_full_r          (tx_fifo_full_r                                               ),//Templated
        .fifo_empty_w         (tx_fifo_empty_w                                              ),//Templated
        .fifo_empty_r         (tx_fifo_empty_r                                              ),//Templated
        .fifo_filled_depth_w  (tx_fifo_filled_depth_w[3:0]                                  ),//Templated
        .fifo_filled_depth_r  (tx_fifo_filled_depth_r[3:0]                                  ),//Templated
        .fifo_waddr_w         (tx_fifo_waddr_w[3:0]                                         ),//Templated
        .fifo_waddr_r         (tx_fifo_waddr_r[3:0]                                         ),//Templated
        .fifo_raddr_w         (tx_fifo_raddr_w[3:0]                                         ),//Templated
        .fifo_raddr_r         (tx_fifo_raddr_r[3:0]                                         ),//Templated
                          // Inputs
        .clk_fifo_w           (aclk                                                         ),
        .rst_fifo_w_n         (aresetn                                                      ),
        .clk_fifo_r           (clk_tx_fifo                                                  ),
        .rst_fifo_r_n         (aresetn                                                      ),
        .fifo_af_lvl_w        (3'd7                                                         ),//Templated
        .fifo_af_lvl_r        (3'd7                                                         ),//Templated
        .fifo_ae_lvl_w        (3'd2                                                         ),//Templated
        .fifo_ae_lvl_r        (3'd2                                                         ),//Templated
        .fifo_wr_en           (tx_fifo_wr_en                                                ),//Templated
        .fifo_wdata           (tx_fifo_wdata[31:0]                                          ),//Templated
        .fifo_rd_en           (tx_fifo_rd_en                                                ));// Templated

// it's better to put file dir into file_dir.vc (-y dir0 -y dir1), but you can choose other method in menu-verilog-xxEmacs-- 
// Local Variables:
// verilog-auto-inst-param-value:t
// verilog-library-flags:("-y /home/users/douxiong/project/spi2axi " ) 

// End:



// verilog-library-directories:("./")
endmodule
//`endif
