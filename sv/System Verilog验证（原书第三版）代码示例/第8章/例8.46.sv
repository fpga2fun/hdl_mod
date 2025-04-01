class TestRegistry;
  static TestBase registry[string];

  static function void register(string name, TestBase t);
    registry[name] = t;
  endfunction  // register

  static function TestBase get_test();
    string name;
    if (!$value$plusargs("TESTNAME = %s", name)) $display("ERROR: No +TESTNAME switch found");
    return registry[name];
  endfunction
endclass  // TestRegistry
