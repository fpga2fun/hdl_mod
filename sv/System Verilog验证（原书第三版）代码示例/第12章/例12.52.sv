#include "svdpi.h"
#include <stdlib.h>
#include <wait.h>

int call_perl(const char* command) {
 int result = system(command);
 return WEXITSTATUS(result);
}