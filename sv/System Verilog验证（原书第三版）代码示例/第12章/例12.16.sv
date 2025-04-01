#ifdef __cplusplus
extern "C" {
#endif

void* counter7_new() {
 return new Counter7;
}

void counter7_count(void* inst){
 Counter7 * c7 = (Counter7 *) inst;
 c7 -> count();
}

void counter7_load(void* inst, const svBitVecVal* i) {
 Counter7 * c7 = (Counter7 *) inst;
 c7 -> load(i);
}

void counter7_reset(void* inst) {
 Counter7 * c7 = (Counter7 *) inst;
 c7 -> reset();
}

int counter7_get(void* inst) {
 Counter7 * c7 = (Counter7 *) inst;
 return c7 -> get();
}

#ifdef __cplusplus
}
#endif