//packet.sv
class Packet;
  rand bit [7:0] length;
  rand bit [7:0] payload[];
  constraint c_valid {
    length > 0;
    payload.size() == length;
  }
  constraint c_external;
endclass
