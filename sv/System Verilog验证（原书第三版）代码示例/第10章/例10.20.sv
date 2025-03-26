class Driver;
  virtual X_if.TB xi;
  int id;
  function new(input virtual X_if.TB xi, input int id);
    this.xi = xi;
    this.id = id;

  endfunction
  task reset();
    $display("@%0t: Driver[%0d]: Start reset", $time, id);
    // 设备复位
    xi.reset_l <= 1;
    xi.cb.load <= 0;
    xi.cb.din  <= '0;
    @(xi.cb) xi.reset_l <= 0;
    @(xi.cb) xi.reset_l <= 1;
    $display("@%0t: Driver[%0d]: End reset", $time, id);
  endtask : reset

  task load_op();
    $display("@%0t: Driver[%0d]: Start load", $time, id);
    ##1 xi.cb.load <= 1;
    xi.cb.din <= id + 10;

    ##1 xi.cb.load <= 0;
    repeat (5) @(xi.cb);
    $display("@%0t: Driver[%0d]: End load", $time, id);
  endtask : load_op

endclass : Driver
