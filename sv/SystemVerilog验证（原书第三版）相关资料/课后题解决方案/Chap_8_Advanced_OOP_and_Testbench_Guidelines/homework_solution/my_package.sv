//////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Package that defines callbacks, Generator, Driver, and Environment classes for
//          Chap_8_Advanced_OOP_and_Testbench_Guidelines/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/13 17:55:51  tumbush.tumbush
// Fixed Makefile for questa_gui. Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:16:11  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/29 19:28:36  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////////////////////////

`include "SV_RAND_CHECK.sv"
package my_package;   

   import packet_pkg::*;
   import scoreboard_pkg::*;

   // Abstract driver callback class.
   virtual 	 class Driver_cbs;
      virtual 	 task pre_tx(ref packet pkt);
	 // By default, callback does nothing
      endtask
      virtual task post_tx(ref packet pkt);
	 // By default, callback does nothing
      endtask
   endclass // Driver_cbs

   // Generator class that creates packets, provides the ability
   // to replace good packets with bad packets,
   // and places the resulting packet in mailbox gen2drv.
class Generator;
   mailbox #(packet) gen2drv;
   packet blueprint;
   function new(input mailbox #(packet) gen2drv);
      this.gen2drv = gen2drv;
      blueprint = new();
   endfunction
   task run();
      packet pkt;
      // $display("Starting Generator::run");
      for (int i=0;i<1000; i++) begin
	 `SV_RAND_CHECK(blueprint.randomize);
	 blueprint.calc_header_checksum();
	 // $display("Correct header checksum is 0x%0h", blueprint.header.header_checksum);
	 if (!$cast(pkt, blueprint.copy()))
	   $display("ERROR: blueprint cannot be copied to pkt");
	 gen2drv.put(pkt); // Send to driver
      end
   endtask
endclass

   // Driver class that gets packet from gen2drv mailbox
   // and checks the callback queue cbs for any requested corruption.
class Driver;
   Driver_cbs cbs[$];
   mailbox #(packet) gen2drv;
   function new(input mailbox #(packet) gen2drv);
      this.gen2drv = gen2drv;
   endfunction // new

   task transmit(packet pkt);
      // pkt.display();
      #10ns;
   endtask // transmit
   
   task run();
      packet pkt;
      // $display("Starting Driver::run");
      forever begin
	 gen2drv.get(pkt);
	 foreach (cbs[i])
           cbs[i].pre_tx(pkt);
	 transmit(pkt);
	 foreach (cbs[i]) 
           cbs[i].post_tx(pkt);
      end
   endtask
endclass // Driver

// Callback to set version to 3 for 1% of packets
class Driver_cbs_v3 extends Driver_cbs;
   virtual task pre_tx(ref packet pkt);
      // Randomly set the version to 3 1% of time
      if ($urandom_range(0,99) == 99) begin // Just pick a number out of 100 to get 1%
	pkt.header.version = 3;
	 // Need to recalculate header checksum
	 pkt.calc_header_checksum();
      end
      
   endtask
endclass // Driver_cbs

// Callback to send packet to scoreboard for comparison 
class Driver_cbs_scoreboard extends Driver_cbs;
   Scoreboard scb;

   virtual task pre_tx(ref packet pkt);
      scb.compare_expected(pkt);
   endtask

   function new(input Scoreboard scb);
      this.scb = scb;
   endfunction
endclass

// Environment class to instantiate the Generator, Driver
// Scoreboard, mailbox gen2drv, and hook them together.
class Environment;
   Generator gen;
   Driver drv;
   Scoreboard scb;
   mailbox #(packet) gen2drv;
   function void build(); // Build the environment by
      gen2drv = new(1); // constructing the mailbox,
      gen = new(gen2drv); // generator,
      drv = new(gen2drv); // and driver
      scb = new();
   endfunction
   task run();
      //$display("Starting Environment::run");
      fork
	 gen.run();
	 drv.run();
      join
   endtask // run

endclass
   
endpackage // my_package
