module    mult_cell
    #(parameter N=4,
      parameter M=4)
    (
      input                     clk,
      input                     rstn,
      input                     en,
      input [M+N-1:0]           mult1,      //������
      input [M-1:0]             mult2,      //����
      input [M+N-1:0]           mult1_acci, //�ϴ��ۼӽ��

      output reg [M+N-1:0]      mult1_o,     //��������λ�󱣴�ֵ
      output reg [M-1:0]        mult2_shift, //������λ�󱣴�ֵ
      output reg [N+M-1:0]      mult1_acco,  //��ǰ�ۼӽ��
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
                //������ӦλΪ1���ۼ�
                mult1_acco  <= mult1_acci + mult1 ;  
            end
            else begin
                mult1_acco  <= mult1_acci ; //������ӦλΪ0�򱣳�
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