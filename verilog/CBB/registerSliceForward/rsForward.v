
`timescale 1ns/1ps

module  CBB_RS_FORWARD #(
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

    reg 						r_mst_o_valid;
    reg [P_DATA_WIDTH-1:0] 		r_mst_o_data;

    assign slv_o_ready = mst_i_ready || (~r_mst_o_valid);

    always @(posedge i_clk or negedge i_rstn) begin : proc_valid
        if(~i_rstn) begin
            r_mst_o_valid <= 1'b0;
        end
        else if (slv_o_ready) begin
            r_mst_o_valid <= slv_i_valid;
        end
    end

    always @(posedge i_clk) begin:proc_data
        if(slv_i_valid & slv_o_ready) begin
            r_mst_o_data <= slv_i_data;
        end
    end

    assign mst_o_valid = r_mst_o_valid;
    assign mst_o_data  = r_mst_o_data;
endmodule
