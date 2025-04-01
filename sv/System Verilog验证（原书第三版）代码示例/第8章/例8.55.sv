`define svm_component_utils(T) \
 typedef svm_component_registry #(T,`"T`") type_id; \
 virtual function string get_type_name(); \
 return `"T`" \
 endfunction

class TestBase extends svm_component;
  Environment env;
  `svm_component_utils(TestBase)

  function new(string name);
    super.new(name);
    $display("%m");
    env = new();
  endfunction

  virtual task run_test();
  endtask
endclass : TestBase
