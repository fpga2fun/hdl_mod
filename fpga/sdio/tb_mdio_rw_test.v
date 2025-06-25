`timescale 1ns / 1ns

module tb_mdio_rw_test();

parameter  PHY_ADDR = 5'h04;           //����PHY��ַ

reg         sys_clk_p;  //ϵͳ�������ʱ��P�� 
reg         sys_clk_n;  //ϵͳ�������ʱ��N�� 
reg         sys_clk  ;  //ϵͳ�������ʱ��N�� 
reg         sys_rst_n;   //ϵͳ��λ���͵�ƽ��Ч
reg         key;         //��������

wire        eth_mdc;    //PHY�����ӿڵ�ʱ���ź�
wire        eth_mdio;   //PHY�����ӿڵ�˫�������ź�
wire [1:0]  led;        //LED��������ָʾ

initial begin
	sys_clk_p = 1'b1;
	sys_clk_n = 1'b0;
	sys_clk   = 1'b1;
	sys_rst_n <= 1'b0;
	key <= 1'b0;
	#201
	sys_rst_n <= 1'b1;
	#120200
	key <= 1'b1;
	#400
	key <= 1'b0;
end
	
always #5 sys_clk_p <= ~sys_clk_p;
always #5 sys_clk_n <= ~sys_clk_n;
always #10 sys_clk <= ~sys_clk;

pullup(eth_mdio);       //MDIO�ź�����

//ΪPHY�Ĵ�������ʼֵ?
reg         we_i;
reg         strobe_i;
reg  [7:0]  address_i;
reg  [7:0]  data_i;

defparam mdio_rw_test_inst.u_mdio_ctrl.TIME_CNT = 1000;

initial begin
    we_i           = 1'b0;
    strobe_i       = 1'b0;     
    address_i      = 8'd0;
    data_i         = 8'd0;
    #200       
    we_i           = 1'b1;         
    strobe_i       = 1'b1; 
    address_i      = 8'h0a; 
    data_i         = 8'h55;
    #20             
    address_i      = 8'h0b;
    data_i         = 8'haa;
    #20            
    address_i      = 8'h40;        //����PHYоƬ��PHY��ַ
    data_i         = PHY_ADDR;            
    #20
    we_i           = 1'b0;
    strobe_i       = 1'b0;    
    address_i      = 8'd0;
    data_i         = 8'd0;    
end

    
mdio_rw_test mdio_rw_test_inst(
    .sys_clk_p  (sys_clk_p), //ϵͳ�������ʱ��P�� 
    .sys_clk_n  (sys_clk_n), //ϵͳ�������ʱ��N�� 
    .sys_rst_n  (sys_rst_n), //ϵͳ��λ���͵�ƽ��Ч
    
    .eth_mdc    (eth_mdc), //PHY�����ӿڵ�ʱ���ź�
    .eth_mdio   (eth_mdio), //PHY�����ӿڵ�˫�������ź�

    .key        (key), //��������
    .led        (led)  //LED��������ָʾ
    );    
	
//����MDIO�ӿڴӻ�����ģ��
mdio_slave_interface u_mdio_slave_interface(
		.rst_n_i    (sys_rst_n),
		.mdc_i      (eth_mdc),
		.mdio       (eth_mdio),

		//wishbone interface 
		.clk_i      (sys_clk),
		.rst_i      (~sys_rst_n),
		.address_i  (address_i),
  		.data_i     (data_i),
  		.data_o     (),
  		.strobe_i   (strobe_i),
  		.we_i		(we_i),
  		.ack_o      ()
    );
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0,tb_mdio_rw_test);
        #5000000 $finish;
    end
endmodule