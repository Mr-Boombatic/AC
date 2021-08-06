#include<stdio.h>

int factorial(int b){
	if (b==0 || b==1)
		return 1;
	return b*factorial(b-1);
}

void main(){
	int b;
	/*scanf("%d",&b);
	if (b>=0) {
		printf("%d = %d\n",b,factorial(b));
	}
	else
		getchar();*/
	factorial(5);
}

