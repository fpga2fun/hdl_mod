struct packed { bit [7:0] r,g,b; } c[];
c = '{'{r:7,g:4,b:9},'{r:3,g:2,b:9},'{r:5,g:2,b:1}};

c.sort with (item.r); // 只对红色（red）像素进行排序
//'{'{r:3，g:2，b:9}，'{r:5，g:2，b:1}，'{r:7，g:4，b:9}};

c.sort(x) with ({x.g,x.b}); // 先对绿色（green）像素后对蓝色（blue）像素进行排序
//'{'{r:5，g:2，b:1}，'{r:3，g:2，b:9}，'{r:7，g:4，b:9}};