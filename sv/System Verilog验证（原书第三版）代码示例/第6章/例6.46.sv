rand bit [31:0] addr;
constraint slow_near_page_boundary {
 addr % 4096 inside {[0:20], [4075:4095]};
}