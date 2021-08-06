.include "my-macro" # подключение файла с макроопределениями
.text # секция команд процесора
.data
  digits_of_n: .ascii "          "
  ten: .long 10
  length: .long 0
  str: .ascii "\n"
  minus: .ascii "-"
.type	Print_Result, @function	# функция циклической обработки массива
.globl	Print_Result		# имя может ИСПОЛЬЗОВАТЬСЯ вне этого исх. файла
Print_Result:

	# Стандартный пролог фунции

  pushl %ebp 	 # сохранить в стеке значение, бывшее в вызывающей
	movl  %esp, %ebp # обеспечить адресный доступ к параметрам и
			 # локальным переменнным в стеке путем базовой
			 # адресации через ebp

	# Тело функции

NextSym:
	movl 8(%ebp), %eax  # адрес параметра-суммы в edx

convert:
  cmpl $0, %eax
  jl Negative
  jmp Positive

Negative:
  # Вывод минуса на экран
  movl $4, %eax		# номер сист. вызова write
	movl $1, %ebx		# параметр 1: дескриптор стандартного вывода
	movl $minus, %ecx	# параметр 2: адрес памяти с выводимыми символами
	movl $1, %edx 	# параметр 3: количество байтов для вывода
	int $0x80

  movl $0, %ebx           # счетчик делений
  movl $9,%esi		# начальное значение индекса на старший байт строки digits_of_n

  movl $0, %eax
  subl 8(%ebp), %eax
  jmp nextdigit

Positive:
  movl $0, %ebx           # счетчик делений
  movl $9, %esi		# начальное значение индекса на старший байт строки digits_of_n
  jmp nextdigit

nextdigit:
  movl $0, %edx           # еще готовим
  idivl ten               # делим объединенные регистры edx:eax на 10
    	                                # частное в  eax, остаток в edx
  addl $48,%edx            # Превращем значение остатка в код цифры

  movb %dl,digits_of_n(%esi)

  #	готовим обработку след. цифры

  addl $1, %ebx           # счетчик делений + 1
  decl %esi		# устанавливаем индекс на байт для
    										# след. цифры
  cmpl $0, %eax           # частное = 0 ?
  jg nextdigit         # НЕТ, продолжаем
  movl %ebx, length       # ДА, сохраняем результат
  PutsRes $digits_of_n


  # Вывод перевода строки на экран
  movl $4, %eax		# номер сист. вызова write
	movl $1, %ebx		# параметр 1: дескриптор стандартного вывода
	movl $str, %ecx	# параметр 2: адрес памяти с выводимыми символами
	movl $1, %edx 	# параметр 3: количество байтов для вывода
	int $0x80



  movl $1, %eax

  # Стандартный эпилог функции
Epilog:
  movl %ebp, %esp # восстановить указатель стека
  popl %ebp       # восстановить ebp
  ret		# возврат в вызывающую

.end
