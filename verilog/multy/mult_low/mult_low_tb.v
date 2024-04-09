`timescale 1ns/1ns

module test ;
    parameter    N = 8 ;
    parameter    M = 4 ;
    reg          clk, rstn;
 
   //clock
    always begin
        clk = 0 ; #5 ;
        clk = 1 ; #5 ;
    end

   //reset
    initial begin
        rstn      = 1'b0 ;
        #8 ;      rstn      = 1'b1 ;
    end

    //no pipeline
    reg                  data_rdy_low ;
    reg [N-1:0]          mult1_low ;
    reg [M-1:0]          mult2_low ;
    wire [M+N-1:0]       res_low ;
    wire                 res_rdy_low ;

    //使用任务周期激励
    task mult_data_in ;  
        input [M+N-1:0]   mult1_task, mult2_task ;
        begin
            wait(!test.u_mult_low.res_rdy) ;  //not output state
            @(negedge clk ) ;
            data_rdy_low = 1'b1 ;
            mult1_low = mult1_task ;
            mult2_low = mult2_task ;
            @(negedge clk ) ;
            data_rdy_low = 1'b0 ;
            wait(test.u_mult_low.res_rdy) ; //test the output state
        end
    endtask

    //driver
    initial begin
        #55 ;
        mult_data_in(25, 5 ) ;
        mult_data_in(16, 10 ) ;
        mult_data_in(10, 4 ) ;
        mult_data_in(15, 7) ;
        mult_data_in(215, 9) ;
		mult_data_in(13, 5) ;
    end

    mult_low  #(.N(N), .M(M))
    u_mult_low
    (
      .clk              (clk),
      .rstn             (rstn),
      .data_rdy         (data_rdy_low),
      .mult1            (mult1_low),
      .mult2            (mult2_low),
      .res_rdy          (res_rdy_low),
      .res              (res_low));

   //simulation finish
   initial begin
      forever begin
         #100;
         if ($time >= 10000)  $finish ;
      end
   end
   
    initial begin
    $dumpfile("wave.vcd");
    $dumpvars;  // tb的模块名
    end
    
endmodule // test