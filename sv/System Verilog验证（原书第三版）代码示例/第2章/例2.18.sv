bit [3:0][7:0] barray[5];  // 5个元素：合并后的4个字节
bit [31:0] lw = 32'h0123_4567;  // 字
bit [7:0][3:0] nibbles;  // 合并数组
barray[0] = lw;
barray[0][3] = 8'h01;
barray[0][1][6] = 1'b1;
nibbles = barray[2];  // 复制合并数组的元素值
