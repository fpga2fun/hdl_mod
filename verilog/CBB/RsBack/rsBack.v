
`timescale 1ns/1ps

module  CBB_RS_BACKWARD#(
        // ---- parameter define
        parameter P_DATA_WIDTH 		= 64
    )(
        // ---- port define
        input 						i_clk,
        input 						i_rstn,

        input 						slv_i_valid,
        input [P_DATA_WIDTH-1:0] 	slv_i_data,
        output 						slv_o_ready,

        output 						mst_o_valid,
        output [P_DATA_WIDTH-1:0] 	mst_o_data,
        input 						mst_i_ready

    );

    reg 						r_mst_i_ready;//所谓的后向打拍器指的就是要把后级的ready信号寄存下来再传送给前级
    always @(posedge i_clk or negedge i_rstn) begin : proc_ready
        if(~i_rstn) begin
            r_mst_i_ready <= 1'b1;
        end
        else if (mst_o_valid) begin
            r_mst_i_ready <= mst_i_ready;
        end
    end

    reg 	[P_DATA_WIDTH-1:0] 	r_mst_o_data;//寄存后级ready的同时还需要把数据寄存下来
    always @(posedge i_clk) begin : proc_data
        if (slv_i_valid & slv_o_ready) begin //当前级valid和寄存后的ready都有效时寄存来自前级的data
            r_mst_o_data <= slv_i_data;
        end
    end
    assign mst_o_data = slv_o_ready ? slv_i_data  : r_mst_o_data;//寄存后的ready有效时输出来自前级的data，后级寄存的ready无效表示此时后级在反压前级，所以需要输出寄存后的data
    assign slv_o_ready= r_mst_i_ready;
    assign mst_o_valid= slv_i_valid | (~slv_o_ready);

endmodule




