`timescale 1ns / 1ps
//
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/26 15:26:54
// Design Name: 
// Module Name: SPI_Master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//

 `timescale 1ns / 1ps
module SPI_Master(
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
    output  wire  [ 7 : 0] tx_wr_data         ,    // Tx Write Data
    //====== ReRAM SPI Interface ===================
    output  wire           SPI_SCLK           ,    // SPI Clock 
    output  wire           SPI_CSN            ,    // SPI Chip Select 
    output  wire           SPI_MOSI           ,    // SPI Master Output 
    input   wire           SPI_MISO                // SPI Master Input
);
   
//==============================================================
// Local Registe Declare 
//==============================================================
//control 
    reg                 r_wr_start     ;// Write Start 
    reg                 r_rd_start     ;// Read  Start 
//status
    reg                 r_wr_finish    ;// Write Finish
    reg                 r_rd_finish    ;// Read  Finish 

    reg     [ 7 : 0]    r_start_addr   ;// Write / Read Start Address
    reg     [ 7 : 0]    r_state_init   ;
    
    reg                 r_wr_mode      ;// Write / Read Mode. 1'b0: Write /1'b1: Read

// Tx 
    reg     [ 7 : 0]    r_tx_wr_data   ;// Tx Write Data 
// SPI Interface 
    reg                 r_sclk         ;  
    reg                 r_sclk_d0      ;// SPI Clock
    
    reg                 r_csn          ;// SPI Chip Select
    reg     [ 3 : 0]    r_csn_cnt      ;// SPI Chip Select Count 

    reg                 r_sclk_enable  ;//SPI Clock enable
    reg     [ 7 : 0]    r_sclk_divider ;// SPI Clock Divider Count 
    
    reg     [ 7 : 0]    r_wr_data      ;// SPI Write Data

    reg     [ 7 : 0]    r_spi_addr_cnt ;// SPI Write / Read Address Count 
    //reg     [11 : 0]    r_spi_data_cnt ;// SPI Write / Read Data    Count
// State
    reg     [ 7 : 0]    state          ;// FSM Current State 
    reg     [ 7 : 0]    state_nxt      ;// ---   Next State       
    
//==============================================================
// Local Wire Declare 
//==============================================================
    wire               sclk_pedge      ;// SPI Clock Positive Edge 
    wire               sclk_nedge      ;// SPI Clock Negative Edge  
    
//==============================================================
// Local Parameter Declare 
//==============================================================  
    localparam  ST_IDLE          = 8'h01;    // Idle  State 
    localparam  ST_CSN_ENABLE    = 8'h02;    // Chip  Select Enable 
    localparam  ST_WRITE_INITIAL = 8'h04;    // Write State Initial 
    localparam  ST_WRITE_ADDR    = 8'h08;    // Write Address 
    localparam  ST_WRITE_DATA    = 8'h10;    // Write Data
    localparam  ST_READ_DATA     = 8'h20;    // Read  Data
    localparam  ST_CSN_DISABLE   = 8'h40;    // Chip  Select Disable 
    localparam  ST_FINISH        = 8'h80;    // Finish State 
    
//==============================================================
// Input control / status
//==============================================================
//read / write start
    always @(posedge sclk)begin
        if(!srstn)begin
            r_wr_start  <=  1'b0;
            r_rd_start  <=  1'b0;
        end
        else begin
            r_wr_start  <=  wr_start;
            r_rd_start  <=  rd_start; 
        end
    end
      
// Write / Read Mode. 1'b0: Write / 1'b1: Read   
    always @(posedge sclk)begin
        if(!srstn)begin
            r_wr_mode   <=  1'b0;
        end
        else if(wr_start) begin
            r_wr_mode   <=  1'b0;
        end
        else if (rd_start)begin
            r_wr_mode   <=  1'b1;        
        end
    end  
//input buffer        
    always @(posedge sclk)begin
        if(!srstn)begin
            r_start_addr  <=  8'h0;
            r_state_init  <=  8'h0;
        end
        else if(wr_start | rd_start)begin
            r_start_addr  <=  start_addr;
            r_state_init  <=  state_init;
        end
    end  
    
//==============================================================
// Generate SPI Clock 
//==============================================================
    always @ (posedge sclk)begin 
        if(!srstn)
            r_sclk_enable   <=  1'b0;
        else if(state==ST_IDLE)
            r_sclk_enable   <=  1'b0;
        else if(state==ST_CSN_ENABLE)
            r_sclk_enable   <=  1'b1;
    end 
//SPI_CLK divider
    always @ (posedge sclk)begin 
        if(!srstn)
            r_sclk_divider <= 8'h0;
        else if(r_sclk_enable) begin 
            if(r_sclk_divider == sclk_divider)
                r_sclk_divider   <= 8'h0;
            else 
                r_sclk_divider   <= r_sclk_divider + 1'b1;
        end 
        else 
            r_sclk_divider <= 8'h0;
    end 

    always @ (posedge sclk)begin
        if(~ srstn)
            r_sclk         <= 1'b0;
        else if(r_sclk_enable) begin 
            if(r_sclk_divider==sclk_divider)
                r_sclk           <= ~ r_sclk;
        end 
        else 
            r_sclk         <= 1'b0;
    end 

    always @ (posedge sclk)begin
        if(~ srstn)
            r_sclk_d0      <= 1'b0;
        else 
            r_sclk_d0      <= r_sclk;
    end 
    
    assign    sclk_pedge   = ~ r_sclk_d0 &    r_sclk ;    // SPI Clock Positive Edge (read /sample data at this edge)
    assign    sclk_nedge   =   r_sclk_d0 & (~ r_sclk);    // SPI Clock Negative Edge (write        data at this edge)   

//==============================================================
// SPI Chip Select 
//==============================================================
    always @ (posedge sclk) begin 
        if(!srstn)
            r_csn_cnt      <= 4'h0;
        else if((state==ST_CSN_ENABLE) | (state==ST_CSN_DISABLE)) begin 
            if(sclk_nedge)
                r_csn_cnt  <= r_csn_cnt + 1'b1;
        end 
        else 
            r_csn_cnt      <= 4'h0;
    end  
            
    always @ (posedge sclk) begin 
        if(!srstn)
            r_csn          <= 1'b1;
        else if(state==ST_CSN_DISABLE)
            r_csn          <= 1'b1;
        else if((state==ST_CSN_ENABLE) & (r_csn_cnt==4'h3) & sclk_nedge)
            r_csn          <= 1'b0;
    end 
 
//==============================================================
// SPI FSM Part 1/3
//==============================================================   
    always @ (posedge sclk) begin 
        if(!srstn)
            state          <= ST_IDLE;
        else 
            state          <= state_nxt;        
    end
 
//==============================================================
// SPI FSM Part 2/3
//==============================================================   
    always @ (*) begin 
        state_nxt   =   ST_IDLE;
        
        case(state)
            ST_IDLE:begin
                if(wr_start | rd_start)
                    state_nxt = ST_CSN_ENABLE;
                else 
                    state_nxt = ST_IDLE;    
            end     
            //======chip select enable===========================
            ST_CSN_ENABLE:begin
                if((r_csn_cnt==4'h3) & sclk_nedge)begin
                    state_nxt = ST_WRITE_INITIAL;     
                end
                else begin
                    state_nxt = ST_CSN_ENABLE;
                end
            end  
            //=====slaver state  initial========================== 
            ST_WRITE_INITIAL:begin
                if((r_spi_addr_cnt[2:0] == 3'h7) &  sclk_nedge)begin
                    state_nxt = ST_WRITE_ADDR;     
                end
                else begin
                    state_nxt = ST_WRITE_INITIAL;
                end            
            end
            //==========write address===========================
            ST_WRITE_ADDR:begin
                if((r_spi_addr_cnt[2:0] == 3'h7) & sclk_nedge)begin
                    if(r_wr_mode)begin
                        state_nxt = ST_READ_DATA;   //read 
                    end 
                    else begin
                        state_nxt = ST_WRITE_DATA; //write
                    end
                end
                else begin
                    state_nxt = ST_WRITE_ADDR;;
                end        
            end                        
            //===========write data===========================
            ST_WRITE_DATA:begin
                if((r_spi_addr_cnt[2:0] == 3'h7) &  sclk_nedge)begin
                    state_nxt = ST_CSN_DISABLE;   //write finish
                end
                else begin
                    state_nxt = ST_WRITE_DATA;;
                end                    
            end  
            //===========read data===========================
            ST_READ_DATA:begin
                if((r_spi_addr_cnt[2:0] == 3'h7) &  sclk_nedge)begin
                    state_nxt = ST_CSN_DISABLE;   //read finish
                end
                else begin
                    state_nxt = ST_READ_DATA;;
                end             
            end                
            //======chip  disable============================
            ST_CSN_DISABLE:begin
                if((r_csn_cnt==4'h3) & sclk_nedge)begin
                    state_nxt = ST_FINISH;     
                end
                else begin
                    state_nxt = ST_CSN_DISABLE;
                end            
            end  
            //============finish=============================
            ST_FINISH:begin
                state_nxt   =   ST_IDLE;
            end  
            default:begin
                state_nxt   =   ST_IDLE;    
            end        
        endcase                  
    end     

//==============================================================
// SPI FSM Part 3/3
//==============================================================   
    always @ (posedge sclk) begin 
        if(!srstn)begin
            r_spi_addr_cnt  <= 8'h0;
            r_wr_data       <= 8'h0;
            r_tx_wr_data    <= 8'h0;
        end    
        else begin
            case(state) 
                ST_IDLE:begin
                    r_spi_addr_cnt  <= 8'h0;
                    r_wr_data       <= 8'h0; 
                    r_tx_wr_data    <= 8'h0;  
                end 
                //==========chip enable========================
                ST_CSN_ENABLE:begin
                    if(sclk_nedge)
                        r_wr_data  <= r_state_init;
                end 
                 //=====slaver state  initial===================
                ST_WRITE_INITIAL:begin
                    if(sclk_nedge)begin
                        if(r_spi_addr_cnt[2:0] == 3'h7)begin
                            r_wr_data  <= r_start_addr; 
                            r_spi_addr_cnt <= 6'h0;    
                        end
                        else begin
                            r_wr_data      <= {r_wr_data[6:0],1'b0}; 
                            r_spi_addr_cnt <= r_spi_addr_cnt+1'b1  ; 
                        end                        
                    end
                end 
                 //==========write address====================
                ST_WRITE_ADDR:begin
                    if(sclk_nedge)begin
                        if(r_spi_addr_cnt[2:0] == 3'h7)begin
                            r_wr_data  <= rx_rd_data;
                            r_spi_addr_cnt <= 6'h0;     
                        end
                        else begin
                            r_wr_data      <= {r_wr_data[6:0],1'b0}; 
                            r_spi_addr_cnt <= r_spi_addr_cnt+1'b1  ; 
                        end
                    end
                end
                //===========write data=========================
                ST_WRITE_DATA:begin
                    if(sclk_nedge)begin
                        if(r_spi_addr_cnt[2:0] == 3'h7)begin
                            r_wr_data  <= rx_rd_data;    
                        end
                        else begin
                            r_wr_data      <= {r_wr_data[6:0],1'b0}; 
                            r_spi_addr_cnt <= r_spi_addr_cnt+1'b1  ; 
                        end
                    end
                end                  
                 //===========read data===========================                             
                ST_READ_DATA:begin
                    if(sclk_pedge)begin //sample at poseitive edge
                        r_wr_data       <= 8'h0;
                        r_tx_wr_data   <= {r_tx_wr_data [6:0],SPI_MISO}; 
                        r_spi_addr_cnt <= r_spi_addr_cnt+1'b1  ; 
                    end
                end
                //========chip  disable============================
                ST_CSN_DISABLE:begin
                    //do nothing
                end
                
                ST_FINISH:begin
                    //do nothing
                end
                //========default============================
                default:begin
                    r_spi_addr_cnt  <= 8'h0;
                    r_wr_data       <= 8'h0;
                    r_tx_wr_data    <= 8'h0;          
                end                                                 
            
            endcase  
        end       
    end
    
    assign  tx_wr_data    =  (r_spi_addr_cnt[2:0] == 3'h7) ? r_tx_wr_data : 8'h0;

//==============================================================
// SPI Finish
//==============================================================
    always @ (posedge sclk) begin 
        if(!srstn)begin
            r_wr_finish    <=   1'b0 ;
            r_rd_finish    <=   1'b0 ;
        end 
        else  
            r_wr_finish    <=   ((state ==ST_FINISH) & (!r_wr_mode));
            r_rd_finish    <=   ((state ==ST_FINISH) & ( r_wr_mode));
    end  

    assign  wr_finish = r_wr_finish ; 
    assign  rd_finish = r_rd_finish ; 
    
    
//==============================================================
// SPI  Output
//==============================================================    
    assign    SPI_SCLK    =  r_sclk;
    assign    SPI_CSN     =  r_csn;
    assign    SPI_MOSI    =  !r_csn ? r_wr_data[7] : 1'b0; 

endmodule

