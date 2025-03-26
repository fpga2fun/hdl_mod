extern int mem_read(int, int, int*);
extern int mem_write(int, int, int);
extern void mem_build(int);
void read_file(char *fname) {
 char cmd;
 int idx;
 FILE *file;
 file = fopen(fname, "r");
 while (!feof(file)) {
 cmd = fgetc(file);
 fscanf(file, "%d ", &idx);
 switch (cmd)
 {
 case 'M': {
 int hi;
 fscanf(file, "%d ", &hi);
 mem_build(hi);
 break;
 }
 case 'R': {
 int addr, data, exp;
 fscanf(file, "%d %d ", &addr, &exp);
 mem_read(idx, addr, &data);
 if (data != exp)
 io_printf("C: Error Data = %d, exp = %d\n", data, exp);
 break;
 }
 case 'W': {
 int addr, data;
 fscanf(file, "%d %d ", &addr, &data);
 mem_write(idx, addr, data);
 break;
 }
 }
 }
 fclose(file);
}