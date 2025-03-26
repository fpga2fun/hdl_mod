module mem(simple_bus sb);
 bit [7:0] data, addr;
 event write_event;
 
 cover property
 (@(posedge sb.clk) sb.write_ena == 1)
 -> write_event;
endmodule