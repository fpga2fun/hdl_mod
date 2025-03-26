 rand bit [31:0] src, dst, data[8]; // 变量
 bit [31:0] csm;

 virtual function void calc_csm(); // 异或所有域
 csm = src ^ dst ^ data.xor;
 endfunction
endclass : Transaction

class BadTr extends Transaction;
 rand bit bad_csm;
 virtual function void calc_csm();
 super.calc_csm(); // 计算正确的 CSM
 if (bad_csm) csm = ~csm; // 产生错误的 CSM 位
 endfunction
endclass : BadTr