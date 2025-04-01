0 for (j = 0; ...
0 0 创建 k0, 产生线程 $write(k) [ 线程 0]
1 0 j++
1 0 1 创建 k1, 产生线程 $write(k) [ 线程 1]
2 0 1 j++
2 0 1 2 创建 k2, 产生线程 $write(k) [ 线程 2]
3 0 1 2 j < 3
3 0 1 2 join_none
3 0 1 2 #0
3 0 1 2 $write(k0) [ 线程 0]
3 0 1 2 $write(k1) [ 线程 1]
3 0 1 2 $write(k2) [ 线程 2]
3 0 1 2 $display;