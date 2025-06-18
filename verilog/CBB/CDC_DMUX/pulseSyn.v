
`timescale 1ns/1ns
module  CBB_PULSE_SYNCHRONIZER #(
        // ---- parameter define
        parameter P_EXTEN_EN		= "ENABLE",  //"ENABLE" or "DISABLE"
        parameter P_EXTEN_MULT 		= 3,	     //2 or larger
        parameter P_SYNC_STAGE 		= 2,	     //2 or larger
        parameter P_PULSE_WIDTH     = "CARE-1"   //"CARE-1" or "NOTCARE"
    )(
        // ---- port define
        input 							i_clk_src,
        input 							i_rstn_src,
        input 							i_pulse_src,//must be register output(source clk)

        input 							i_clk_dst,
        input 							i_rstn_dst,
        output 							o_pulse_dst

    );

    reg [P_EXTEN_MULT-2:0] 			r_pluse_src_dly;
    reg 				   			r_pulse_exten;
    reg [P_SYNC_STAGE-1:0]			r_pulse_sync;

    generate
        if(P_EXTEN_EN == "ENABLE") begin
            if(P_EXTEN_MULT <= 2) begin
                always @(posedge i_clk_src or negedge i_rstn_src) begin : proc_pulse_exten1
                    if(~i_rstn_src) begin
                        r_pluse_src_dly <= {(P_EXTEN_MULT-1){1'b0}};
                    end
                    else begin
                        r_pluse_src_dly <= {i_pulse_src};
                    end
                end
                always @(posedge i_clk_src or negedge i_rstn_src) begin : proc_pulse_exten2
                    if(~i_rstn_src) begin
                        r_pulse_exten <= 1'b0;
                    end
                    else begin
                        r_pulse_exten <= |{r_pluse_src_dly,i_pulse_src};
                    end
                end
                always @(posedge i_clk_dst or negedge i_rstn_dst) begin : proc_pulse_sync
                    if(~i_rstn_dst) begin
                        r_pulse_sync <= {(P_SYNC_STAGE){1'b0}};
                    end
                    else begin
                        r_pulse_sync <= {r_pulse_sync[P_SYNC_STAGE-2:0],r_pulse_exten};
                    end
                end
            end
            else begin
                always @(posedge i_clk_src or negedge i_rstn_src) begin : proc_pulse_exten
                    if(~i_rstn_src) begin
                        r_pluse_src_dly <= {(P_EXTEN_MULT-1){1'b0}};
                    end
                    else begin
                        r_pluse_src_dly <= {r_pluse_src_dly[P_EXTEN_MULT-3:0],i_pulse_src};
                    end
                end
                always @(posedge i_clk_src or negedge i_rstn_src) begin : proc_pulse_exten2
                    if(~i_rstn_src) begin
                        r_pulse_exten <= 1'b0;
                    end
                    else begin
                        r_pulse_exten <= |{r_pluse_src_dly,i_pulse_src};
                    end
                end
                always @(posedge i_clk_dst or negedge i_rstn_dst) begin : proc_pulse_sync
                    if(~i_rstn_dst) begin
                        r_pulse_sync <= {(P_SYNC_STAGE){1'b0}};
                    end
                    else begin
                        r_pulse_sync <= {r_pulse_sync[P_SYNC_STAGE-2:0],r_pulse_exten};
                    end
                end
            end
        end
        else begin
            always @(posedge i_clk_dst or negedge i_rstn_dst) begin : proc_pulse_sync
                if(~i_rstn_dst) begin
                    r_pulse_sync <= {(P_SYNC_STAGE){1'b0}};
                end
                else begin
                    r_pulse_sync <= {r_pulse_sync[P_SYNC_STAGE-2:0],i_pulse_src};
                end
            end
        end
    endgenerate
    generate
        if(P_PULSE_WIDTH == "CARE-1") begin
            assign o_pulse_dst = r_pulse_sync[P_SYNC_STAGE-2] & (~r_pulse_sync[P_SYNC_STAGE-1]);
        end
        else begin
            assign o_pulse_dst = r_pulse_sync[P_SYNC_STAGE-1];
        end
    endgenerate

endmodule
/* @wavedrom case2
{
    signal : [
        { name: "clk"  ,  wave: "p......|p....." },
        { name: "Valid",  wave: "0.1...0|..1..0" },
        { name: "data" ,  wave: "x.3...x|..4..x" , data: "data1 data2"}
    ]
}
*/