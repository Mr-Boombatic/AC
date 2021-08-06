/**
 * math.S -- вычисляет и печатает число Пи
 *
 * Copyright (c) 2014 Petrozavodsk State University
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
	*/


	/* Объявляем внешние имена (необязательно) */

	.extern printf
	.extern scanf


	/* Секция данных */

	.data

fmt:
	.asciz "%.25lf\n" # форматная строка для printf

dbl:
	.double .0	# вещественнозначное число типа double


	/* Секция команд процессора */
	.text

	.global calc_pi_1
	.global calc_pi_2
	.global calc_pi_3


	/** print_double_by_ptr
 *    выводит вещественнозначное число типа double на экран с помощью вызова
 *    функции printf стандартной библиотеки языка Си
	*/
print_double_by_ptr:
	pushl %ebp		# сохраняем контекст стека
	movl %esp, %ebp

	movl 8(%ebp), %eax	# получаем указатель на число
	pushl 4(%eax)	# сохраняем старшую половину
	pushl (%eax)	# сохраняем младшую половину
	pushl $fmt	# сохраняем адрес форматной строки
	call printf	# выводим на экран
	addl $12, %esp	# восстанавливаем указатель стека

	movl %ebp, %esp	# восстанавливаем контекст стека
	popl %ebp
	ret			# завершаем подпрограмму


	/** calc_pi_1
 *    вычисляет значение числа пи с помощью встроенной функции загрузки
 *    числа пи на вершину стека fpu
	*/
calc_pi_1:
	pushl %ebp		# сохраняем контекст стека
	movl %esp, %ebp

	fldpi		# загружаем число Пи на вершину стека

	movl 8(%ebp), %eax	# извлекаем из параметра адрес
	fstpl (%eax)	# выталкиваем результат по адресу

	movl %ebp, %esp	# восстанавливаем контекст стека
	popl %ebp
	ret			# завершаем подпрограмму


	/** calc_pi_2
 *    вычисляет значение числа пи с помощью формулы Мэчина
	*/
calc_pi_2:
	pushl %ebp		# сохраняем контекст стека
	movl %esp, %ebp

	subl $4, %esp	# резервируем память под локальную переменную


	fld1		# st(0) <- 1
	movl $239, -4(%ebp)
	fild -4(%ebp)	# st(0) <- 239, st(1) <- 1
	fpatan	# st(0) <- arctg(1/239)

	fld1		# st(0) <- 1, st(0) <- arctg(1/239)
	movl $5, -4(%ebp)
	fild -4(%ebp)	# st(0) <- 5, st(1) <- 1, st(2) <- arctg(1/239)
	fpatan	# st(0) <- arctg(1/5), st(1) <- arctg(1/239)

	movl $4, -4(%ebp)
	fild -4(%ebp)	# st(0) <- 4, st(1) <- arctg(1/5), st(2) <- arctg(1/239)
	fmulp	# st(0) <- 4 * arctg(1/5), st(1) <- arctg(1/239)

	fsubp		# st(0) <- 4 * arctg(1/5) - arctg(1/239)

	fild -4(%ebp)	# st(0) <- 4, st(1) <- 4 * arctg(1/5) - arctg(1/239)
	fmulp	# st(0) <- 4 * (4 * arctg(1/5) - arctg(1/239))

	movl 8(%ebp), %eax	# извлекаем из параметра адрес
	fstpl (%eax)	# выталкиваем результат по адресу

	movl %ebp, %esp	# восстанавливаем контекст стека
	popl %ebp

	ret			# завершаем подпрограмму

calc_pi_3:
	pushl %ebp		# сохраняем контекст стека
	movl %esp, %ebp

	subl $4, %esp	# резервируем память под локальную переменную

	fld1
	movl $57, -4(%ebp)
	fild -4(%ebp)
	fpatan			# arctan(1/57)

	movl $44, -4(%ebp)
	fild -4(%ebp)
	fmulp 			# 44arctan(1/57)

	fld1
	movl $239, -4(%ebp)
	fild -4(%ebp)
	fpatan			# arctan(1/239)

	movl $7, -4(%ebp)
	fild -4(%ebp)
	fmulp 			# 7arctan(1/239)

	faddp			# 44arctan(1/57) + 7arctan(1/239)

	fld1
	movl $682, -4(%ebp)
	fild -4(%ebp)
	fpatan			# arctan(1/682)

	movl $-12, -4(%ebp)
	fild -4(%ebp)
	fmulp 			# 12arctan(1/682)

	faddp			# 44arctan(1/57) + 7arctan(1/239) - 12arctan(1/682)
	
	fld1
	movl $12943, -4(%ebp)
	fild -4(%ebp)
	fpatan			# arctan(1/12943)

	movl $24, -4(%ebp)
	fild -4(%ebp)
	fmulp 			# 24arctan(1/12943)

	faddp			# 44arctan(1/57) + 7arctan(1/239) - 12arctan(1/682)
				# + 24arctan(1/12943)
	movl $4, -4(%ebp)
	fild -4(%ebp)
	fmulp			# Получили pi

	movl 8(%ebp), %eax	# извлекаем из параметра адрес
	fstpl (%eax)		# выталкиваем результат по адресу

	movl %ebp, %esp		# восстанавливаем контекст стека
	popl %ebp
	
	ret
