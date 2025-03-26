extern int mem_read(int, int*);
extern int mem_write(int, int);
extern void mem_build(int);

void read_file(const char *fname) {
 char cmd;
 FILE *file;

 file = fopen(fname, "r");
 while (!feof(file)) {
  cmd = fgetc(file);
  switch (cmd) {
   case 'M': {
    int hi;
    fscanf(file, "%d ", &hi);
    mem_build(hi);
    break;
   }

   case 'R': {
    int addr, data, exp;
    fscanf(file, "%d %d ", &addr, &exp);
    mem_read(addr, &data);
    if (data != exp)
     io_printf("C: Data = %d, exp = %d\n", data, exp);
    break;
   }

   case 'W': {
    int addr, data;
    fscanf(file, "%d %d ", &addr, &data);
    mem_write(addr, data);
    break;
   }

  }
 }
 fclose(file);
}