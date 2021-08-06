# Функции as , вызываемые из С
.include "my-macro"
.globl	Numbers	# имя, ОПРЕДЕЛЕННОЕ вне этого исходного файла

.text # секция команд процесора

.type	Sum_Numbers, @function	# функция циклической обработки массива
.globl	Sum_Numbers		# имя может ИСПОЛЬЗОВАТЬСЯ вне этого исх. файла
Sum_Numbers:

	# Стандартный пролог фунции

	pushl %ebp 	 # сохранить в стеке значение, бывшее в вызывающей
	movl  %esp, %ebp # обеспечить адресный доступ к параметрам и
			 # локальным переменнным в стеке путем базовой
			 # адресации через ebp

	# Тело функции

NextSym:
	movl 12(%ebp), %edx  # адрес второго параметра-числа в edx
  movl 8(%ebp), %ecx  # адрес первого параметра-числа в ecx

  subl %eax, %eax
  addw %cx, %ax
  addw %dx, %ax

  jo CancelSum
  jmp Epilog

	# конец Sum_Numbers
CancelSum:
  subl %eax, %eax
  movw %cx, %ax
  pusha
  Puts "Overflow"
  popa

  # Стандартный эпилог функции
Epilog:
  movl %ebp, %esp # восстановить указатель стека
  popl %ebp       # восстановить ebp
  ret		# возврат в вызывающую

.end
