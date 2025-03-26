// 重复每个测试
class TestSimple extends TestBase;
  function new();
    env = new();
    TestRegistry::register("TestIimple", this);
  endfunction
  virtual task run_test();
    $display("%m");
    env.gen_config();
    env.build();
    env.run();
    env.wrap_up();
  endtask
endclass
TestSimple TestSimple_handle = new();  // 每个类都需要
