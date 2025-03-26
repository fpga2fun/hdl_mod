task automatic load_array(input int len, ref int array[]);
 if (len <= 0) begin
 $display("Bad len");
 return;
 end
 
 // 任务中其余的代码
 ...
endtask