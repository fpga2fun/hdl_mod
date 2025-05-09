`timescale 1ns / 1ps
module Dff_t;
    reg rst_n =1;
    reg clk = 0;
    reg data_in = 0;
    wire data_out;
    Dff dff(.clk(clk), .rst_n(rst_n), .data_in(data_in), .data_out(data_out));
    //时钟产生
    always begin
        #10 clk = ~clk;
    end
    //异步复位信号
    initial begin
         rst_n =0;
        #3 rst_n =1;
    end
    //同步数据输入
    initial begin
        @(posedge clk);
        repeat (25) begin
            @(posedge clk);
             data_in <= 1;
            @(posedge clk);
             data_in <= 0;
        end
        $finish;
    end
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0,Dff_t);
        #500 $finish;
    end

endmodule
