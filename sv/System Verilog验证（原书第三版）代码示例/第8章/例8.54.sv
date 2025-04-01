class svm_factory;
  // 根据字符串检索 svm_object_wrapper 句柄的关联数组
  static svm_object_wrapper m_type_names[string];

  static svm_factory m_inst;  // 单例类的句柄

  static function svm_factory get();
    if (m_inst == null) m_inst = new();
    return m_inst;
  endfunction

  static function void register(svm_object_wrapper c);
    m_type_names[c.get_type_name()] = c;
  endfunction

  static function svm_component get_test();
    string name;
    svm_object_wrapper test_wrapper;
    svm_component test_comp;
    if (!$value$plusargs("SVM_TESTNAME = %s", name)) begin
      $display("FATAL +SVM_TESTNAME not found");
      $finish;
    end
    $display("%m found +SVM_TESTNAME = %s", name);
    test_wrapper = svm_factory::m_type_names[name];
    $cast(test_comp, test_wrapper.create_object(name));
    return test_comp;
  endfunction
endclass : svm_factory
