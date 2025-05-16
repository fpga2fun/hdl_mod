`timescale 1ns / 1ns		//时间单位/精度

module tb();

    localparam	SYNC_STAGE = 2;		//同步级数
    localparam	DATA_WIDTH = 8;		//数据位宽

    //源时钟域的信号（即同步前的信号）
    reg							clk_source			;	//源时钟（慢时钟）
    reg							rst_source			;	//高有效的同步复位
    reg							sig_pulse_source	;	//同步前的脉冲信号
    reg	[DATA_WIDTH - 1:0]		sig_data_source		;	//同步前的数据信号
    //目的时钟域的信号（即同步后的信号）
    reg							clk_dest			;	//目的时钟（快时钟）
    reg							rst_dest			;	//高有效的同步复位
    wire	[DATA_WIDTH - 1:0]	sig_data_dest		;	//同步后的数据信号
    wire						sync_busy			;	//握手忙信号

    reg	[9:0]	period_source	;	//源时钟的周期，随机值，0-1024ns
    reg	[9:0]	period_dest		;	//目的时钟的周期，随机值，不到源时钟周期的一半，即二者的频率满足两倍关系


    //生成源时钟
    initial begin
        period_source = {$random%1024};
        clk_source = 1'b0;
        //	#({$random%1024});				//给一个随机相位，这样两个时钟就是完全异步的
        forever begin
            #period_source;
            clk_source = ~clk_source;
        end
    end

    //生成目的时钟
    initial begin
        period_dest = {$random%(period_source/2)};
        clk_dest = 1'b0;
        //	#({$random%1024});				//给一个随机相位，这样两个时钟就是完全异步的
        forever begin
            #period_dest;
            clk_dest = ~clk_dest;
        end
    end

    //生成源时钟的复位信号
    initial begin
        rst_source = 1'b1;		//上电复位即有效
        @(posedge clk_source);
        @(posedge clk_source);
        rst_source = 1'b0;		//保证至少维持一个时钟周期才释放
    end

    //生成目的时钟的复位信号
    initial begin
        rst_dest = 1'b1;		//上电复位即有效
        @(posedge clk_dest);
        @(posedge clk_dest);
        rst_dest = 1'b0;		//保证至少维持一个时钟周期才释放
    end

    initial begin
        sig_pulse_source = 1'b0;
        sig_data_source = 0;
        @(negedge rst_dest);	//等待复位完成
        repeat(10) begin		//随机生成脉冲信号，执行10次
            @(posedge clk_source);
            sig_pulse_source <= $random && (~sync_busy);	//反压上级
            //sig_pulse_source <= $random;
            sig_data_source <= sync_busy ? sig_data_source : $random;	//如果BUSY则不变，否则生成随机值
            @(posedge clk_source);
            sig_pulse_source <= 1'b0;
        end
        $stop();
    end

    //例化被测试模块
    sync_handshake #(
                       .SYNC_STAGE			(SYNC_STAGE			)
                       .DATA_WIDTH			(DATA_WIDTH			)
                   )
                   u_sync_shake
                   (
                       .clk_source			(clk_source			),
                       .rst_source			(rst_source			),
                       .sig_pulse_source	(sig_pulse_source	),
                       .sig_data_source	(sig_data_source	),
                       .clk_dest			(clk_dest			),
                       .rst_dest			(rst_dest			),
                       .sig_data_dest		(sig_data_dest		),
                       .sync_busy			(sync_busy			)
                   );
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        #5000 $finish;
    end
endmodule
