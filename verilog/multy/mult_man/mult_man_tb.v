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
	reg          data_rdy ;
    reg [N-1:0]  mult1 ;
    reg [M-1:0]  mult2 ;
    wire                 res_rdy ;
    wire [N+M-1:0]       res ;

	initial begin
    $dumpfile("wave.vcd");
    $dumpvars;	// tb的模块名
	end
	
    //driver
    initial begin
        #55 ;
        @(negedge clk ) ;
        data_rdy  = 1'b1 ;
        mult1  = 25;      mult2      = 5;
        #10 ;      mult1  = 16;      mult2      = 10;
        #10 ;      mult1  = 10;      mult2      = 4;
        #10 ;      mult1  = 15;      mult2      = 7;
        mult2      = 7;   repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 1;   repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 15;  repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 3;   repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 11;  repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 4;   repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 9;   repeat(32)    #10   mult1   = mult1 + 1 ;
    end

    //对输入数据进行移位，方便后续校验
    reg  [N-1:0]   mult1_ref [M-1:0];
    reg  [M-1:0]   mult2_ref [M-1:0];
    always @(posedge clk) begin
        mult1_ref[0] <= mult1 ;
        mult2_ref[0] <= mult2 ;
    end

    genvar         i ;
    generate
        for(i=1; i<=M-1; i=i+1) begin
            always @(posedge clk) begin
            mult1_ref[i] <= mult1_ref[i-1];
            mult2_ref[i] <= mult2_ref[i-1];
            end
        end
    endgenerate
   
    //自校验
    reg  error_flag ;
    always @(posedge clk) begin
        # 1 ;
        if (mult1_ref[M-1] * mult2_ref[M-1] != res && res_rdy) begin
            error_flag <= 1'b1 ;
        end
        else begin
            error_flag <= 1'b0 ;
        end
    end

    //module instantiation
    mult_man  #(.N(N), .M(M))
     u_mult
     (
      .clk              (clk),
      .rstn             (rstn),
      .data_rdy         (data_rdy),
      .mult1            (mult1),
      .mult2            (mult2),
      .res_rdy          (res_rdy),
      .res              (res));
	  
	     //simulation finish
   initial begin
      forever begin
         #100;
         if ($time >= 10000)  $finish ;
      end
   end

endmodule // test