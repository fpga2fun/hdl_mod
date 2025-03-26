class BadTr extends Transaction;
 rand bit bad_csm;

 virtual function void calc_csm();
 super.calc_csm(); // 计算正确的 csm
 if (bad_csm) csm = ~csm; // 产生错误的 csm 位
 endfunction
 
 virtual function void display(input string prefix = "");
 $write("%sBadTr: bad_csm = %b, ", prefix, bad_csm);
 super.display();
 endfunction