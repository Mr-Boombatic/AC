//#include "stdio.h"

int testcpuid(){
    int r = 0;
    
    __asm__(
	"movl $0, %%eax;\n\t"
	"cpuid;\n\t"
	"movl %%eax, %0;\n\t"
	:"=r" (r)
	);
    if(r<1){
	//printf("CPUID 1 не поддерживается.\n");
	return 2;
    }
    else{
	__asm__(
	    "movl $1, %%eax;\n\t"
	    "cpuid;\n\t"
	    "and $0x000001, %%edx;\n\t"
	    "movl %%edx, %0;\n\t"
	    :"=r" (r)
	    );
	if(r==0){
	    // printf("Математический сопроцессор отсутствует.\n");
	    return 1;
	}
	else{
	    //printf("Математический сопроцессор имеется.\n");
	}
    }
    return 0;
}
