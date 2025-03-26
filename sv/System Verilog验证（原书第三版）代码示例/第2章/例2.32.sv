int count, total, d[] = '{9, 1, 8, 3, 4, 4};

count = d.sum with (item > 7);  // 2=sum{1,0,1,0,0,0}
total = d.sum with ((item > 7) * item);  // 17=sum{9,0,8,0,0,0}
count = d.sum with (item < 8);  // 4=sum{0,1,0,1,1,1}
total = d.sum with (item < 8 ? item : 0);  // 12=sum{0,1,0,3,4,4}
count = d.sum with (item == 4);  // 2=sum{0,0,0,0,1,1}
