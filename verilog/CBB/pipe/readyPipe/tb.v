`timescale 1ns/1ns

module tb;

    parameter DWIDTH = 8;

    reg clk;
    reg rstn;
    reg [DWIDTH-1:0] i_data;
    reg i_valid;
    wire i_ready;
    wire [DWIDTH-1:0] o_data;
    wire o_valid;
    reg o_ready;
    reg [7:0] i;
    // DUT实例化
    pipe_skid_buffer #(.DWIDTH(DWIDTH)) dut (
                         .clk(clk),
                         .rstn(rstn),
                         .i_data(i_data),
                         .i_valid(i_valid),
                         .i_ready(i_ready),
                         .o_data(o_data),
                         .o_valid(o_valid),
                         .o_ready(o_ready)
                     );

    // 时钟生成
    initial begin
        clk = 0;
        forever
            #5 clk = ~clk; // 10ns周期
    end

    // 复位
    initial begin
        rstn = 0;
        i      <= 1;
        i_data <= 0;
        i_valid <= 0;
        o_ready <= 0;
        repeat(2) @(posedge clk);
        rstn = 1;
    end

    initial begin
        @(posedge rstn);
        @(posedge clk);
        o_ready <= 1;

        repeat(60) begin
            @(posedge clk);
            o_ready <= $random();
            ;
        end
        repeat(10) @(posedge clk);
        $finish; // Finish simulation
    end
    initial begin
        @(posedge rstn)
         repeat(55) begin
             //            @(posedge clk);
             send_data(i);
             i = i + 1;
         end
     end
     // 发送数据任务
     task send_data(input [DWIDTH-1:0] data);
         begin
             @(posedge clk);
             i_data <= data;
             i_valid <= 1;
             @(posedge clk);
             while (!i_ready) begin
                 @(posedge clk);
             end
             i_valid <= 0;
         end
     endtask

     // 监控输出
     always @(posedge clk) begin
         if (o_valid && o_ready)
             $display("Time %0t: Output data = 0x%0h", $time, o_data);
     end
     initial begin
         $dumpfile("tb.vcd");
         $dumpvars(0, tb);
         #5000 $finish;
     end
 endmodule
