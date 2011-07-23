#define OPDEF(op,val,name,image,length,nuses,ndefs,prec,format) `define op 8B_##val
#include "jsopcode.tbl"
