`timescale 1 ns/1 ns
module test();
    parameter	CYCLE		=   10      ;//系统时钟周期，单位ns，默认10ns；
    parameter	RST_TIME	=   10      ;//系统复位持续时间，默认10个系统时钟周期；

    reg			                clk     ;//系统时钟，默认100MHz；
    reg			                rst     ;//系统复位，默认高电平有效；
    reg                         clk_en  ;
    reg                         din     ;

    wire                        dout1   ;
    wire                        dout2   ;

    iddr_ctrl  u_iddr_ctrl (
        .clk    ( clk       ),
        .rst    ( rst       ),
        .clk_en ( clk_en    ),
        .din    ( din       ),
        .dout1  ( dout1     ),
        .dout2  ( dout2     )
    );

    //生成周期为CYCLE数值的系统时钟;
    initial begin
        clk = 1;
        forever #(CYCLE/2) clk = ~clk;
    end

    //生成复位信号；
    initial begin
        rst = 0;
        #2;
        rst = 1;//开始时复位10个时钟；
        #(RST_TIME*CYCLE);
        rst = 0;
        repeat(120) @(posedge clk);
        $stop;//停止仿真；
    end

    initial begin
        #1;
        din = 1'b0;clk_en = 1'b0;
        #(CYCLE*(10+RST_TIME));
        clk_en = 1'b1;
        #(CYCLE);
        repeat(100)begin//产生100个双沿时钟数据。
            #(CYCLE/2);
            din = ({$random} % 2);
            #(CYCLE/2);
            din = ({$random} % 2);
        end
        #(CYCLE);
        clk_en = 1'b0;
    end
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0,test);
        #500 $finish;
    end

endmodule