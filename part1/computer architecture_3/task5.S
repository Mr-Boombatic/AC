.include "my-macro"
.bss
	.lcomm c, 1
.data
	A: 	
		.long 11, 12, 13, 14, 15, 16
		.long 21, 22, 23, 24, 25, 26
		.long 31, 32, 33, 34, 35, 36
		.long 41, 42, 43, 44, 45, 46
		.long 51, 52, 53, 54, 55, 56
		.long 61, 62, 63, 64, 65, 66
		

	i:	.long 0
	j:	.long 0
	n:	.long 0
	k:	.long 0
	l:	.long 0
	bi:	.long 0
	m:	.long 0
	
.text
.global _start
_start:
	nop
prompt:
	PutStr "Введите K и L\n"
input:
	Getchar $c
	cmpb $'0', c
	jb input
	cmpb $'5', c
	ja input
	subl $'0', c
	incl %esi
	cmpl $2, %esi
	jb k_assign
	jae l_assign 
	jmp input
T_2:
	movl $A, %edx
next_string:
	subl %ebx, %ebx
T_1:
	movl (%edx, %ebx, 2), %eax
	movl %eax, n
	addl $2, %ebx
	movl %ebx, j
	movl %edx, i
	PutInt n
	PutStr " "
	movl j, %ebx
	movl i, %edx
	cmpl $12, %ebx
	jne T_1	
	addl $24, %edx
	cmpl $A + 144, %edx
	jne T_4
	je done
	jmp prompt
done:
	PutStr "\n"
	jmp T_3
T_4:
	movl %ebx, j
	movl %edx, i
	PutStr "\n"
	movl j, %ebx
	movl i, %edx
	jmp next_string

l_assign:
	movb c, %al
	movb %al, l
        jmp T_2
k_assign:
	movb c, %al
	movb %al, k	
	jmp input	
T_3:
	PutStr "Вектор b:\n"
	subl %ebx, %ebx	
	movl k, %eax
	movl $24, %ecx
	mull %ecx	
	movl %eax, k
	movl l, %eax
	movl $2, %ecx
	mull %ecx	
	movl %eax, l
	movl $A, m
loop:
	movl m, %edx
	movl $A, %edx
	addl k, %edx
	movl (%edx, %ebx, 4), %eax
	movl %eax, bi
	movl %ebx, j
	movl %edx, i
	movl l, %ebx
	movl m, %edx
	movl (%edx, %ebx, 2), %eax
	addl %eax, bi
	addl $24, %edx
	movl %edx, m
 	PutInt bi
	PutStr " "
	movl j, %ebx
	movl i, %edx
	addl $1, %ebx
	cmpl $6, %ebx
	jne loop
done_calc:
	PutStr "\n"
	jmp prompt
exit:
	Finish
.end

