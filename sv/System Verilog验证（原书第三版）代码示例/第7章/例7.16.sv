parameter TIME_OUT = 1000ns;

task check_trans(input Transaction tr);
  fork

    begin
      // 等待回应，或者达到某个最大时延
      fork : timeout_block
        begin
          wait (bus.cb.data == tr.data);
          $display("@%0t: data match %d", $time, tr.data);
        end
        #TIME_OUT $display("@%0t: Error: timeout", $time);
      join_any
      disable timeout_block;
    end

  join_none  // 产生线程，无阻塞
endtask
