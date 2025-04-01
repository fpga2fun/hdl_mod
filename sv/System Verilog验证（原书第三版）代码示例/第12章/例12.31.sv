#define PRINT_SIZE 12
#define MAX_CALLS 16
#define HEAP_SIZE PRINT_SIZE * MAX_CALLS
char *print(p_rgb rgb) {
 static char print_heap[HEAP_SIZE + PRINT_SIZE];
 char *s;
 static int heap_idx = 0;
 int nchars;
 s = &print_heap[heap_idx];
 nchars = sprintf(s, "%02x,%02x,%02x",
 rgb->r, rgb->g, rgb->b);
 heap_idx += nchars + 1; // 不要忘了 null 值！
 if (heap_idx > HEAP_SIZE)
 heap_idx = 0;
 return s;
}