//////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Package that defines tests for 
//          Chap_8_Advanced_OOP_and_Testbench_Guidelines/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test_pkg.sv,v $
// Revision 1.1  2011/05/29 19:16:11  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/29 19:28:37  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////////////////////////


package test_pkg;

   import packet_pkg::*;
   import scoreboard_pkg::*;
   import my_package::*;

   // Base test class. Must be virtual since it contains
   // pure virtual functions.
   virtual class TestBase;
      Environment env;
      function new();
	 env = new();
      endfunction
      virtual task run_test();
      endtask;
   endclass

   // Test registry class 
class TestRegistry;
   static TestBase registry[string];
   static function void register(string name, TestBase t);
      registry[name] = t;
   endfunction
   static function TestBase get_test();
      string name;
      if (!$value$plusargs("TESTNAME=%s", name))
        $display("ERROR: No +TESTNAME switch found");
      else
        $display("%m found +TESTNAME=%s", name);
      return registry[name];
   endfunction
endclass

class TestGood extends TestBase;
   function new();
      env = new();
      TestRegistry::register("TestGood", this);
   endfunction
   
   virtual   task run_test();
      $display("%m");
      env.build();
      begin
	Driver_cbs_scoreboard dcs = new(env.scb);
	env.drv.cbs.push_back(dcs); 
      end
      env.run();
   endtask
endclass // TestGood

class Test_v3 extends TestBase;
   function new();
      env = new();
      TestRegistry::register("Test_v3", this);
   endfunction
   
   virtual   task run_test();
      $display("%m");
      env.build();
      begin // Create error injection callback
	 Driver_cbs_v3 v3_cb = new();
	 Driver_cbs_scoreboard dcs = new(env.scb);    
	 env.drv.cbs.push_back(v3_cb);
	 env.drv.cbs.push_back(dcs);
      end

      env.run();
   endtask
endclass // TestGood

class TestBad extends TestBase;
   function new();
      env = new();
      TestRegistry::register("TestBad", this);
   endfunction
   
   virtual   task run_test();
      $display("%m");
      env.build();
      
      begin // Create error injection callback
	 bad_packet bad = new();
	 Driver_cbs_scoreboard dcs = new(env.scb);
	 bad.calc_header_checksum();
	 env.gen.blueprint = bad;
	 env.drv.cbs.push_back(dcs); 
      end

      env.run();
   endtask
endclass // TestGood

   
endpackage // test_pkg
   