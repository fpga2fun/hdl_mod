class BusOp;
 ...
 
 constraint c_addr_space {
 if (addr_space == MEM) 
 addr inside {[0:32'h0FFF_FFFF]};
 else if (addr_space == IO)
 addr inside {[32'1000_0000:32'h7FFF_FFFF]};
 else 
 addr inside {[32'8000_0000:32'hFFFF_FFFF]};
 }
 endclass