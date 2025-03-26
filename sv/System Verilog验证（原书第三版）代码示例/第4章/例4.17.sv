module memory(input wire start, write,
 input wire [7:0] addr, 
 inout wire[7:0] data);
 logic [7:0] mem[256];
 always @(posedge start) begin
 if (write)
 mem[addr] <= data;
 ...
 end
endmodule

module test(output logic start, write,
 output logic [7:0] addr, data);
 initial begin
 start = 0; // 信号初始化
 write = 0;
 #10; // 短暂的延时
 addr = 8'h42; // 发起第一个指令
 data = 8'h5a;
 start = 1;
 write = 1;
 ...
 end
endmodule