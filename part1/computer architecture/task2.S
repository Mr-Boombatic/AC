.include "my-macro"	# подключение файла с макроопределениями

.text
        
.global _start
_start:	
        movl $5, %eax/*записывает значение 5 в регистр eax*/
	movl $1, %ebx/*записывает 1 в регистр ebx */

L1: 	
        cmpl  $0, %eax/*сравниваем значение 0 с eax*/
	je    L2/*если равно то переходим L2*/
	imull %eax, %ebx /*умножение eax на ebx резульат запис. в ebx*/
	decl  %eax /*уменьшение eax на 1*/
	jmp   L1 /*переход к метке L1*/
	
L2:	
        Finish/*завершение программы*/
.end
