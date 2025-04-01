extern void sv_display();
svScope my_scope;

void save_my_scope() {
 my_scope = svGetScope();
}

void c_display() {
 // 打印当前作用域
 io_printf("\nC: c_display called from scope %s\n",
 svGetNameFromScope(svGetScope()));
 
 // 设置新的作用域
 svSetScope(my_scope);
 io_printf("C: calling %s.sv_display\n",
 svGetNameFromScope(svGetScope()));
 sv_display();
}