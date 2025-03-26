virtual class TestBase;
  Environment env;
  pure virtual task run_test();
  function new();
    env = new();
  endfunction
endclass
