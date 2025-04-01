int d[] = '{9,1,8,3,4,4}, tq[$];

// 找出所有大于 3 的元素
tq = d.find with (item > 3);             // {9,8,4,4}
// 等效代码
tq.delete();
foreach (d[i])
    if (d[i] > 3)
        tq.push_back(d[i]);

tq = d.find_index with (item > 3);       // {0,2,4,5}
tq = d.find_first with (item > 99);      // {}-没有找到
tq = d.find_first_index with (item==8);  // {2} d[2]=8
tq = d.find_last with (item==4);         // {4}
tq = d.find_last_index with (item==4);   // {5} d[5]=4
