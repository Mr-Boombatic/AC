/**
 * sand_watch.S -- выводит приветственную строку в виде песочных часов
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
	greeting: .asciz "Hello from Assembler!"
	endline: .asciz "\n"
	empty_string: .asciz "          "	
    	
/* Секция команд процессора */
.text
.type Print_Spaces, @function     # функция печати начальных пробелов

Print_Spaces:
	
        /* Стандартный пролог фунции */
        pushl %ebp       	# сохранить в стеке значение, бывшее в вызывающей
        movl  %esp, %ebp 	# обеспечить адресный доступ к параметрам и 
				# локальным переменнным в стеке путем базовой 
				# адресации через ebp

	movl 8(%ebp), %edx 	# Вытаскиваем параметр функции
	movl $4, %eax           # помещаем номер системного вызова write                        
	movl $1, %ebx           # помещаем номер дескриптора файла в регистр ebx
	leal empty_string, %ecx
	int $0x80

	/* Стандартный эпилог функции */
	movl %ebp, %esp # восстановить указатель стека
        popl %ebp       # восстановить ebp
        ret             # возврат в вызывающую

    /* Метка _start адресует точку входа - первую инструкцию в секции
       команд процессора, которая будет исполнена при загрузке программы */

    .global _start
    _start:                           

    /* Многократно выводим строку на экран в виде песочных часов */

	movl $21, %esi          # фиксируем счетчик символов-повторений
	subl %edi, %edi      	# Обнуляем счетчик начальных пробелов

next_step:
	pusha
	pushl %edi              # Кол-во пробелов в начале
	call Print_Spaces
	
	movl $4, %eax           # помещаем номер системного вызова write
				# в регистр eax                            
	movl $1, %ebx           # помещаем номер дескриптора файла в регистр ebx,
				# единица соответствует стандартному выводу, stdout
	leal greeting, %ecx     # помещаем адрес выводимой строки в регистр ecx
				# (объясните, почему не movl greeting, %ecx
	addl %edi, %ecx
	movl %esi, %edx         # помещаем в регистр edx количество байт, начиная с
				# заданного адреса, которые нужно отправить в файл
	int  $0x80
				# обращаемся к обработчику системных вызовов
				# ОС Linux, который выполняет вызов по его номеру

	/* endline */
	movl $4, %eax
	movl $1, %ebx
	leal endline, %ecx
	movl $1, %edx
	int $0x80

	/* if */
	cmpl $1, %esi           # если требуемое число повторений достигнуто,
	je back_step            # переходим к завершению программы
	subl $2, %esi           # уменьшаем счетчик
	addl $1, %edi
	jmp next_step           # иначе повторяем еще раз

back_step:
	subl $1, %edi
	addl $2, %esi
	
	pusha
	pushl %edi              # Кол-во пробелов в начале
	call Print_Spaces

	movl $4, %eax           # помещаем номер системного вызова write
				# в регистр eax                            
	movl $1, %ebx           # помещаем номер дескриптора файла в регистр ebx,
				# единица соответствует стандартному выводу, stdout
	leal greeting, %ecx     # помещаем адрес выводимой строки в регистр ecx
				# (объясните, почему не movl greeting, %ecx
	addl %edi, %ecx
	movl %esi, %edx         # помещаем в регистр edx количество байт, начиная с
				# заданного адреса, которые нужно отправить в файл
	int  $0x80
				# обращаемся к обработчику системных вызовов
				# ОС Linux, который выполняет вызов по его номеру
	
	/* endline */
	movl $4, %eax
	movl $1, %ebx
	leal endline, %ecx
	movl $1, %edx
	int $0x80

	/* if */
	cmpl $21, %esi
	je done
	jmp back_step

done:                          
    /* Завершаем выполнение программы с помощью системного вызова _exit */
    
    movl $1, %eax           # помещаем номер системного вызова _exit
                            # в регистр eax
    movl $0, %ebx           # помещаем код возврата в регистр ebx,
                            # нулевой код соответствует успешному завершению
    int  $0x80              # обращаемся к ОС

.end                        # последняя строка исходного текста
