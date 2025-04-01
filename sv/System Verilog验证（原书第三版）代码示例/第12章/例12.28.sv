typedef struct {
 unsigned char b, g, r; // x86 小尾序
 //unsigned char r, g, b; // SPARC 格式
} *p_rgb;
void invert(p_rgb rgb) {
 rgb -> r = ~rgb -> r; // 色彩值取反
 rgb -> g = ~rgb -> g;
 rgb -> b = ~rgb -> b;
 io_printf("C: Invert rgb = %02x,%02x,%02x\n",
 rgb -> r, rgb -> g, rgb -> b);
}