//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           mdio_rw_test
// Last modified Date:  2020/2/6 17:25:36
// Last Version:        V1.0
// Descriptions:        MDIO�ӿڲ���
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2020/2/6 17:25:36
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module mdio_rw_test(
    input          sys_clk_p, //ϵͳ�������ʱ��P�� 
    input          sys_clk_n, //ϵͳ�������ʱ��N�� 
    input          sys_rst_n, //ϵͳ��λ���͵�ƽ��Ч
    //MDIO�ӿ�
    output         eth_mdc  , //PHY�����ӿڵ�ʱ���ź�
    inout          eth_mdio , //PHY�����ӿڵ�˫�������ź�
    
    input          key      , //��������
    output  [1:0]  led        //LED��������ָʾ
    );
    
//wire define
wire          sys_clk    ;  //ϵͳʱ��
wire          op_exec    ;  //������ʼ�ź�
wire          op_rh_wl   ;  //�͵�ƽд���ߵ�ƽ��
wire  [4:0]   op_addr    ;  //�Ĵ�����ַ
wire  [15:0]  op_wr_data ;  //д��Ĵ���������
wire          op_done    ;  //��д���
wire  [15:0]  op_rd_data ;  //����������
wire          op_rd_ack  ;  //��Ӧ���ź� 0:Ӧ�� 1:δӦ��
wire          dri_clk    ;  //����ʱ��
/*
//ת������ź�
IBUFDS diff_clock
(
    .I (sys_clk_p),    //ϵͳ�������ʱ��P��     
    .IB(sys_clk_n),    //ϵͳ�������ʱ��N�� 
    .O (sys_clk)       //���ϵͳʱ��
); 
*/
assign sys_clk = sys_clk_p; //ϵͳʱ��P��

//MDIO�ӿ�����
mdio_dri #(
    .PHY_ADDR    (5'h04),    //PHY��ַ 3'b100
    .CLK_DIV     (6'd16)     //��Ƶϵ��
    )
    u_mdio_dri(
    .clk        (sys_clk),
    .rst_n      (sys_rst_n),
    .op_exec    (op_exec   ),
    .op_rh_wl   (op_rh_wl  ),   
    .op_addr    (op_addr   ),   
    .op_wr_data (op_wr_data),   
    .op_done    (op_done   ),   
    .op_rd_data (op_rd_data),   
    .op_rd_ack  (op_rd_ack ),   
    .dri_clk    (dri_clk   ),  
                 
    .eth_mdc    (eth_mdc   ),   
    .eth_mdio   (eth_mdio  )   
);      

//MDIO�ӿڶ�д����    
mdio_ctrl  u_mdio_ctrl(
    .clk           (dri_clk),  
    .rst_n         (sys_rst_n ),  
    .soft_rst_trig (key  ),  
    .op_done       (op_done   ),  
    .op_rd_data    (op_rd_data),  
    .op_rd_ack     (op_rd_ack ),  
    .op_exec       (op_exec   ),  
    .op_rh_wl      (op_rh_wl  ),  
    .op_addr       (op_addr   ),  
    .op_wr_data    (op_wr_data),  
    .led           (led       )
);      

endmodule