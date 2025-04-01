class Statistics;
 time startT; //Transaction 的时间戳
 ... // 类的其余部分参见例 5.22
 function Statistics copy();
 copy = new();
 copy.startT = startT;
 endfunction
endclass