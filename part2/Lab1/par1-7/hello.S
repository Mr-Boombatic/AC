/**
 * hello.S -- выводит приветственную строку на стандартный вывод
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

	/* Секция данных */

	.data

	    /* Размещаем нуль-терминальную строку в области глобальных
	инициализированных данных, метка greeting адресует строку */

greeting:	 .asciz "Hello from Assembler!\n"


	/* Секция команд процессора */

	.text

	    /* Метка _start адресует точку входа - первую инструкцию в секции
	команд процессора, которая будет исполнена при загрузке программы */
	.global _start
_start:

	/* Выводим строку на экран с помощью системного вызова write ОС Linux */

	movl $4, %eax	# помещаем номер системного вызова write
	##  в регистр eax,
	movl $1, %ebx	# помещаем номер дескриптора файла в регистр ebx,
	##  единица соответствует стандартному выводу, stdout
	leal greeting, %ecx	# помещаем адрес выводимой строки в регистр ecx
	##  (объясните, почему не movl greeting, %ecx
	movl $22, %edx	# помещаем в регистр edx количество байт, начиная с
	##  заданного адреса, которые нужно отправить в файл
	int  $0x80		# обращаемся к обработчику системных вызовов
	##  ОС Linux, который выполняет вызов по его номеру

	/* Завершаем выполнение программы с помощью системного вызова _exit */

	movl $1, %eax	# помещаем номер системного вызова _exit
	##  в регистр eax
	movl $0, %ebx	# помещаем код возврата в регистр ebx,
	##  нулевой код соответствует успешному завершению
	int  $0x80		# обращаемся к ОС


	.end			# последняя строка исходного текста
