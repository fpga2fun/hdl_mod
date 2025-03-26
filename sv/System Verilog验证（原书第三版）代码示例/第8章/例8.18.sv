// 不推荐
class EthMacFrame;
 typedef enum {II, IEEE} kind_e;
 rand kind_e kind;
 rand bit [47:0] da, sa;
 rand bit [15:0] len;
 ...
endclass

class Vlan extends EthMacFrame;
 rand bit [15:0] vlan;
endclass