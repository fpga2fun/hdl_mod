//test.sv
program automatic test;
'include "packet.sv"
 constraint Packet::c_external {length == 1;}
 ...
endprogram