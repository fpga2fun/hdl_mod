virtual class svm_component extends svm_object;
  protected svm_component m_children[string];
  string name;

  function new(string name);
    this.name = name;
    $display("%m name = '%s'", name);
  endfunction

  pure virtual task run_test();
endclass
