class eth_mac_frame;
 typedef enum {II, IEEE} kind_e;
 rand kind_e kind;
 rand bit [47:0] da, sa;
 rand bit [15:0] len, vlan;
 rand bit [ 7:0] data[];
 ...
 constraint eth_mac_frame_II {
 if (kind == II) {
 data.size() inside {[46:1500]};
 len == data.size();
 }}
 constraint eth_mac_frame_ieee {
 if (kind == IEEE) {
 data.size() inside {[46:1500]};
 len < 1522;
 }}
endclass