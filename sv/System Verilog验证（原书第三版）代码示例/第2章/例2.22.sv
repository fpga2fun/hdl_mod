int
    j = 1,
    q2[$] = {3, 4},  // 队列的常量不需要使用 “'”
    q[$] = {0, 2, 3};  // {0,2,3}

initial begin
  q.insert(1, j);  // {0,1,2,3}     在 #1号元素之前插入 j
  q.delete(1);  // {0,2,3}   删除#1号元素

  // 下面的操作执行速度很快
  q.push_front(6);  // {6,0,2,3} 在队列前面插入
  j = q.pop_back;  // {6,0,2}   j = 3
  q.push_back(8);  // {6,0,2,8} 在队列末尾插入
  j = q.pop_front;  // {0,2,8}   j = 6
  foreach (q[i]) $display(q[i]);  // 打印整个队列
  q.delete();  // {}            删除队列
end
