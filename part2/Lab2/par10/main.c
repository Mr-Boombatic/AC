#include "stdio.h"
#include "testcpuid.h"

int main(){
     int status = testcpuid();
     switch(status){
     case 0: printf("Математический сопроцессор имеется.\n");
	 break;
     case 1: printf("Математический сопроцессор отсутсвует.\n");
	 break;
     case 2: printf("Функция 1 инструкции cpuid недоступна.\n");
     }
     return 0;
}
