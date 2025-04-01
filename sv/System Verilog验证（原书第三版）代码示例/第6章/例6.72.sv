initial begin
  //Level 1
  randcase
    one_write_wt: do_one_write();
    one_read_wt:  do_one_read();
    seq_write_wt: do_seq_write();
    seq_read_wt:  do_seq_read();
  endcase
end

//Level 2
task do_one_write();
  randcase
    mem_write_wt: do_mem_write();
    io_write_wt:  do_io_write();
    cfg_write_wt: do_cfg_write();
  endcase
endtask

task do_one_read();
  randcase
    mem_read_wt: do_mem_read();
    io_read_wt:  do_io_read();
    cfg_read_wt: do_cfg_read();
  endcase
endtask
