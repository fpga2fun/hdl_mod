

`timescale 1ns/1ps

module  tb();
    // ---- parameter define
    parameter P_DATA_WIDTH 		= 32;

    // ---- port define
    reg 						i_clk;
    reg 						i_rstn;

    reg 						slv_i_valid;
    reg [P_DATA_WIDTH-1:0] 		slv_i_data;
    wire 						slv_o_ready;

    wire 						mst_o_valid;
    wire [P_DATA_WIDTH-1:0] 	mst_o_data;
    reg 						mst_i_ready;

    initial
        i_clk = 1'b0;
    always #5 i_clk = ~i_clk;

    integer time_dly1,time_dly2;

    integer sim_ctrl;

    initial begin
        i_rstn = 1'b0;
        mst_i_ready = 1'b0;
        #20;
        i_rstn = 1'b1;
        #20;
        repeat(20) begin
            time_dly1 = $urandom_range(1,10);
            repeat(time_dly1) begin
                @(posedge i_clk);
            end
            @(posedge i_clk)
             mst_i_ready <= 1'b1;

            time_dly1 = $urandom_range(1,10);
            repeat(time_dly1) begin
                @(posedge i_clk);
            end
            @(posedge i_clk)
             mst_i_ready <= 1'b0;
        end
    end

    initial begin
        sim_ctrl = 1;
        slv_i_valid = 1'b0;
        slv_i_data  = 0;
        @(posedge i_rstn);
        #20;
        repeat(20) begin
            @(posedge i_clk)
             slv_i_valid <= 1'b1;
            slv_i_data  <= $random;
            while(~slv_o_ready)
                @(posedge i_clk);
            @(posedge i_clk)
             slv_i_valid <= 1'b0;
            slv_i_data  <= 0;

            time_dly2 = $urandom_range(1,10);
            repeat(time_dly2) @(posedge i_clk);
        end
        #200;
        sim_ctrl = 0;
        #100;
        $finish;
    end

    integer file_handle_slv,file_handle_mst;
    initial begin
        file_handle_slv = $fopen("./CBB_RS_BACKWARD_SLV_DATA.txt","w+");

        while(sim_ctrl) begin
            if(slv_i_valid&slv_o_ready) begin
                $fdisplayh(file_handle_slv,slv_i_data);
                $display("slv_i_data = %h",slv_i_data);
                @(posedge i_clk);
            end
            else begin
                @(posedge i_clk);
            end
        end
        $fclose(file_handle_slv);
    end

    initial begin
        file_handle_mst = $fopen("./CBB_RS_BACKWARD_MST_DATA.txt","w+");

        while(sim_ctrl) begin
            if(mst_o_valid&mst_i_ready) begin
                $fdisplayh(file_handle_mst,mst_o_data);
                @(posedge i_clk);
            end
            else begin
                @(posedge i_clk);
            end
        end
        $fclose(file_handle_mst);
    end

    CBB_RS_BACKWARD #(
                        .P_DATA_WIDTH(P_DATA_WIDTH)
                    ) U_CBB_RS_BACKWARD (
                        .i_clk       (i_clk),
                        .i_rstn      (i_rstn),
                        .slv_i_valid (slv_i_valid),
                        .slv_i_data  (slv_i_data),
                        .slv_o_ready (slv_o_ready),
                        .mst_o_valid (mst_o_valid),
                        .mst_o_data  (mst_o_data),
                        .mst_i_ready (mst_i_ready)
                    );
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,tb);
        #5000 $finish;
    end
endmodule
