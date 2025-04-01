task wait_for_time_out(input int id);
  if (id == 0)
    fork
      begin
        #2ns;
        $display("@%0t: disable wait_for_time_out", $time);
        disable wait_for_time_out;
      end
    join_none

  fork : just_a_little
    begin
      $display("@%0t: %m: %0d entering thread", $time, id);
      #TIME_OUT;
      $display("@%0t: %m: %0d done", $time, id);
    end
  join_none
endtask

initial begin
  wait_for_time_out(0);  // 产生线程 0
  wait_for_time_out(1);  // 产生线程 1
  wait_for_time_out(2);  // 产生线程 2
  #(TIME_OUT * 2) $display("@%0t: All done", $time);
end
