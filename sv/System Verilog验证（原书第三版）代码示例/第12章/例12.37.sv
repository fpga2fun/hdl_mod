#include <svdpi.h>
#include <stdio.h>
extern void mem_build(int);
void read_file(char *fname){
 char cmd;
 FILE *file;
 file = fopen(fname, "r");
 while (!feof(file)) {
 cmd = fgetc(file);
 switch (cmd)
 {
 case 'M': {
 int hi;
 fscanf(file, "%d ", &hi);
 mem_build(hi);
 break;
 }
 }
 }
 fclose(file);
}