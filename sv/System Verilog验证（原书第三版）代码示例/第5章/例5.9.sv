Transaction t;  // 创建一个句柄
t = new();  // 分配一个新的 Transaction
t = new();  // 分配第二个，并且释放第一个 t
t = null;  // 解除分配第二个
