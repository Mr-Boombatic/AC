.include "my-macro"

.bss
	.lcomm n, 1 
	.lcomm buf, 15

.data
	t: .short 0
	ten: .short 10
	sum: .short 0
	a: .byte 0
	c: .byte 0
	copy: .byte 0
	ct: .byte 0
.text
.global _start 

_start:
	subl %eax, %eax
	subl %esi, %esi
show_prompt:
	Puts "Вводитее цифры"
kbd_input:
	Getchar $n
	cmpl $0,%eax
	je nextdigit
	cmpb $'\n', n
	je re
	cmpb $'9', n
	ja mv
	cmpb $'0', n 
	jb mv
	movb $0,ct
	cmpb $'-',copy
	je minus
next:
	movb n, %al 
	sub $48, %al 
	movb %al, c
	movb n, %al
	movb %al, copy
	jmp kbd_input
re:
	movb c, %al 
	subb $48, %al  
	addw %ax, sum
	jo stop_2
	jmp kbd_input
nextdigit:
	cmpw $0, s
	jl output_summ_negative
	subl %esi,%esi
	movw sum,%ax
nextdigit_1:
	movw $0, %dx
	cmpw $0, %ax
	je put_symbol 
	divw ten
	addw $48, %dx 
	movw %dx, buf(%esi)
	incl %esi
	jmp nextdigit_1
put_symbol:
	decl %esi
put:
	movl buf(%esi), %edi
	movl %edi, a
	Put_number $a 
	decl %esi
	cmpl $0, %esi  
	jge put 
	Puts ""
	jmp s_1
stop:
	Exit $0
stop_2:
	Puts "Переполнение "
	Exit $0
s_2:
	movw $8,ten
	Puts "Вывод в восьмеричной системе"
	addb $1,t
	jmp nextdigit
s_1:
	cmpb $1,t
	je stop
	cmpw $2,ten
	je s_2
	movw $2,ten
	Puts "Вывод в двоичной системе"
	jmp nextdigit
mv:
	movb $0, c
	movb n, %al
	movb %al,copy
	jmp kbd_input
minus:
	movb $1, ct
	jmp next
output_summ_negative:
	movl $'-', a
	Put_number $a
	movw $0, %ax
	subw sum, %ax
	movl $0, %esi
	movw %ax, sum
	jmp nextdigit
