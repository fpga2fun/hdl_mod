module    mult_cell
    #(parameter N=4,
      parameter M=4)
    (
      input                     clk,
      input                     rstn,
      input                     en,
      input [M+N-1:0]           mult1,      //被乘数
      input [M-1:0]             mult2,      //乘数
      input [M+N-1:0]           mult1_acci, //上次累加结果

      output reg [M+N-1:0]      mult1_o,     //被乘数移位后保存值
      output reg [M-1:0]        mult2_shift, //乘数移位后保存值
      output reg [N+M-1:0]      mult1_acco,  //当前累加结果
      output reg                rdy );

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rdy            <= 'b0 ;
            mult1_o        <= 'b0 ;
            mult1_acco     <= 'b0 ;
            mult2_shift    <= 'b0 ;
        end
        else if (en) begin
            rdy            <= 1'b1 ;
            mult2_shift    <= mult2 >> 1 ;
            mult1_o        <= mult1 << 1 ;
            if (mult2[0]) begin
                //乘数对应位为1则累加
                mult1_acco  <= mult1_acci + mult1 ;  
            end
            else begin
                mult1_acco  <= mult1_acci ; //乘数对应位为0则保持
            end
        end
        else begin
            rdy            <= 'b0 ;
            mult1_o        <= 'b0 ;
            mult1_acco     <= 'b0 ;
            mult2_shift    <= 'b0 ;
        end
    end

endmodule