class svm_component_registry #(type T = svm_component,
 string Tname = "<unknown>")
 extends svm_object_wrapper;

 typedef svm_component_registry #(T,Tname) this_type;

 virtual function string get_type_name();
 return Tname;
 endfunction

 local static this_type me = get(); // 单例的句柄

 static function this_type get(); 
 if (me = null) begin // 有实例吗？
 svm_factory f = svm_factory::get(); // 构造 factory
 me = new(); // 构造单例
 f.register(me); // 注册类
 end
 return me;
 endfunction

 virtual function svm_object create_object(string name = "");
 T obj;
 obj = new(name);
 return obj;
 endfunction
 
 static function T create(string name);
 create = new(name);
 endfunction

endclass : svm_component_registry