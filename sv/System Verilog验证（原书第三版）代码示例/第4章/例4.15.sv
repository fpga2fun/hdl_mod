interface asynch_if();
 logic l;
 wire w;
endinterface

module test(asynch_if ifc);
 logic local_wire;
 assign ifc.w = local_wire;
 
 initial begin
 ifc.l <= 0; // 直接驱动异步 login
 local_wire <= 1; // 通过 assign 语句驱动 wire
 ...
 end 
endmodule