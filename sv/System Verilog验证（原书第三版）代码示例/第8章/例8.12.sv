Transaction tr;
BadTr bad;
bad = new(); // 构建 BadTr 扩展对象
tr = bad; // 基类句柄指向扩展对象
 // tr 向下转换指向扩展对象
$display(tr.src); // 显示基类对象的变量成员
tr.display; // 调用 BadTr::display