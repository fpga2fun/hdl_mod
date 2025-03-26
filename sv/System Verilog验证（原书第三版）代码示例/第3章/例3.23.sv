program automatic test ();
  task wait_for_bus(input logic [31:0] addr, expect_data, output logic success);
    while (bus_addr !== addr) @(bus_addr);
    success = (bus_data == expect_data);
  endtask

endprogram
