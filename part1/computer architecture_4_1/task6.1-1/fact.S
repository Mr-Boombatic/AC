/*

    Подпрограммы и соглашения о связях

*/
.include "my-macro" # подключение файла с макроопределениями

.data # секция данных, распределение памяти
	result:	.long 0
        number: .long 0
        digits_of_n:	.ascii "          "
        length: .long 0         # количество 10 цифр в числе
        ten: 	.long 10       # делитель

.bss
	.lcomm buf, 100		# Буфер для хранения прочитанных символов. Размер - 100 байт
	.lcomm c, 1		# Буфер для чтения текущего символа. Размер - 1 байт

.text # секция команд процесора

.type   Fact, @function     # функция вычисления факториала числа

Fact:

/*
        Читает число из стека и вычисляет его факториал
*/
#       Стандартный пролог фунции

  pushl %ebp       # сохранить в стеке значение, бывшее в вызывающей
  movl  %esp, %ebp # обеспечить адресный доступ к параметрам и
                         # локальным переменнным в стеке путем базовой
                         # адресации через ebp
	subl $4, %esp
	movl $1, -4(%ebp)   # Локальная переменная

#       Тело функции
FactStep:
  cmpl $0, 8(%ebp)		# Сравнение с нулем
  je Return 		# Если равно 0 то завершаем функцию

	movl 8(%ebp), %ecx
	movl %ecx, -4(%ebp)
	decl 8(%ebp)

	pushl 8(%ebp)
	call Fact
	addl $4, %esp
	mull -4(%ebp)

EndReturn:
	movl %ebp, %esp # восстановить указатель стека
	popl %ebp       # восстановить ebp
	ret             # возврат в вызывающую

Return:
	movl %ebp, %esp # восстановить указатель стека
	movl $1, %eax
	popl %ebp       # восстановить ebp
	ret             # возврат в вызывающую




.global _start # точка входа - глобальная метка

_start:

  nop

  pusha   # сохранение регистров главной программы

  Puts "Введите число < 13"

kbd_input:
  Getchar $c          # макровызов ввода символа со стандартного ввода

  cmpl $0, %eax 	# Конец файл - EOF (введено 0 символов) ?
  je stop

  cmpb $'\n', c 	# это символ перевода строки ?
  je get_digit 	# ДА - на сохранение цифры в буфер

  cmp $100, %esi 	# Проверка заполнения буфера
  je buff_end

  cmpb $'9', c  	# код больше кода символа '9' ?
  ja print_err_msg	# ДА - на вывод сообщения об ошибке
  cmpb $'0', c	        # код меньше кода символа '0' ?
  jb print_err_msg      # ДА - на вывод сообщения об ошибке


  movb c, %al         # код из с пишем в al
  movb %al, buf(%esi) # Загрузить содержимое al (введенный символ) в байт по
        											# адресу buf + esi (буфер для вводимых символов)
  incl %esi						# указать на следующий адрес буфера для следующего символа

  jmp kbd_input	# на ввод следующего символа

print_err_msg:
	Puts "Число должно состоять из цифр 0-9 и быть меньше 13"	# вывод сообщения об ошибке
	subl %esi, %esi
  jmp kbd_input 	# на ввод следующего символа

buff_end:
  Puts "Буфер закончился"
  jmp stop

get_digit:
	movl $0, number 
	cmp $0, %esi
	je kbd_input

	decl %esi
	sub %eax, %eax
	movb buf(%esi), %al
	sub $48, %eax

	addl %eax, number

	cmp $0, %esi
	je call_func

	decl %esi
	sub %eax, %eax
	movb buf(%esi), %al
	incl %esi
	incl %esi
	sub $48, %eax

	movl %eax, %ebx
	movl $10, %eax
	mul %ebx

	addl %eax, number
	cmp $12, number
	ja print_err_msg

call_func:
	incl %esi
	pushl number        # Число в стек
	movl $1, %eax
	call Fact   # вызов функции
	movl %eax, result

	addl $4,%esp    # очистить стек от параметров Read_Sym
	popa         # восстановить регистры главной програмы

convert:
  	movl $0, %ebx           # счетчик делений
  	movl result, %eax       # готовим деление
  	movl $9,%esi		# начальное значение индекса на старший байт строки digits_of_n

nextdigit:
  	movl $0, %edx           # еще готовим
  	idivl ten               # делим объединенные регистры edx:eax на 10
  	                        # частное в  eax, остаток в edx
	addl $48,%edx           # Превращем значение остатка в код цифры

  	movb %dl,digits_of_n(%esi)

  	#	готовим обработку след. цифры

	addl $1, %ebx           # счетчик делений + 1
  	decl %esi		# устанавливаем индекс на байт для
  												# след. цифры
  	cmpl $0, %eax           # частное = 0 ?
  	jg nextdigit            # НЕТ, продолжаем
  	movl %ebx, length       # ДА, сохраняем результат
  	PutsRes $digits_of_n
  	Puts ""

stop:
  Exit $0
  .end
