0 for (j = 0; ...
0 产生线程 $write(j) [ 线程 0]
1 j++ j = 1
1 产生线程 $write(j) [ 线程 1]
2 j++ j = 2
2 产生线程 $write(j) [ 线程 2]
3 j++ j = 3
3 join_none
3 #0 $display 前的延时
3 $write(j) [ 线程 0:j =3 ]
3 $write(j) [ 线程 1:j = 3]
3 $write(j) [ 线程 2:j = 3]
3 $display;