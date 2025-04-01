typedef struct packed {
  bit [7:0]  addr;
  bit [7:0]  pr;
  bit [15:0] data;
} Packet;

Packet scb[$];

function void check_addr(bit [7:0] addr);
  int intq[$];

  intq = scb.find_index() with (item.addr == addr);
  case (intq.size())
    0: $display("Addr %h not found in scoreboard", addr);
    1: scb.delete(intq[0]);
    default: $display("ERROR: Multiple hits for addr %h", addr);
  endcase
endfunction : check_addr
