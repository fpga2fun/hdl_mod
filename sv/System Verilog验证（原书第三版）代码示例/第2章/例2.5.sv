parameter int MEM_SIZE = 256;
parameter int ADDR_WIDTH = $clog2(MEM_SIZE);  //$clog2(256) = 8
bit [15:0] mem[MEM_SIZE];
bit [ADDR_WIDTH-1:0] addr;  //[7:0]
