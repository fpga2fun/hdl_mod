initial begin
  $display("@%0t: start fork...join_any example", $time);
  #10 $display("@%0t: sequential after #10", $time);
  fork
    $display("@%0t: parallel start", $time);
    #50 $display("@%0t: parallel after #50", $time);
    #10 $display("@%0t: parallel after #10", $time);
    begin
      #30 $display("@%0t: sequential after #30", $time);
      #10 $display("@%0t: sequential after #10", $time);
    end
  join_any
  $display("@%0t: after join_any", $time);
  #80 $display("@%0t: finish after #80", $time);
end
