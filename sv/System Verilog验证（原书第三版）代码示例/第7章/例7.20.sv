event e1, e2;
initial begin
 $display("@%0t: 1: before trigger", $time);
 -> e1;
 @e2;
 $display("@%0t: 1: after trigger", $time);
end

initial begin
 $display("@%0t: 2: before trigger", $time);
-> e2;
 @e1;
 $display("@%0t: 2: after trigger", $time);
end