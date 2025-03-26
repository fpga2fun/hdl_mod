rand bit [31:0] addr;
constraint near_page_boundry {
 addr[11:0] inside {[0:20], [4075:4095]};
}