/**
 * cpuid.S -- печатает сведения о подсистемах процессора
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

errmess:
        .string "CPUID is not supported\n"

nocpuidone:
        .string "CPUID 1 function is not supported\n"

hasfpu:
        .string "Has x87 FPU on Chip\n"

hasnofpu:
        .string "Has no x87 FPU on Chip\n"

hasmmx:
        .string "Has mmx\n"

hasnommx:
        .string "Has no mmx\n"

/* Секция команд процессора */

.text

    .global _start                      # точка входа - глобальная метка
    _start:

    /* Подготавливаем стек к работе с локальными переменными */
        pushl %ebp                      # сохраняем текущий контекст стека
        movl  %esp, %ebp
        subl  $20, %esp                 # резервируем 16 байт для локального
                                        # буфера

    /* Анализируем, доступна ли инструкция cpuid */
        pushfl                          # получаем содержимое регистра флагов
        popl %eax                       # в регистре eax
        movl %eax, %ebx                 # сохраняем копию регистра флагов
        xorl $0x00200000, %eax          # меняем бит 21 на противоположный
        pushl %eax                      # сохраняем измененное значение
        popfl                           # в регистре флагов
        pushfl                          # снова получаем регистр флагов
        popl %eax
        xorl %ebx, %eax                 # если бит не сохранился
        je no_cpuid                     # cpuid не поддерживается

    /* Получим идентификатор производителя процессора */
        movl $0, %eax                  # загружаем код функции регистр eax
        cpuid                          # получаем строку производителя
        movl %eax, -20(%ebp)
        movl %ebx, -16(%ebp)           # в регистрах ebx, edx, ecx
        movl %edx, -12(%ebp)           # сохранаем в буфер
        movl %ecx, -8(%ebp)
        movb $10, -4(%ebp)             # помещаем символ перевода строки в
                                       # в конец буфера


    /* Выводим идентификационную строку производителя ЦП на экран */
        movl $4, %eax                  # помещаем номер системного вызова
                                       # write в регистр eax
        movl $1, %ebx                  # помещаем номер стандартного потока 
                                       # вывода (stdout) в ebx
        movl %ebp, %ecx                # помещаем адрес начала буфера выводе
        subl $16, %ecx                 # в ecx
        movl $13, %edx                 # помещаем длину строки в edx
        int $0x80                      # обращаемся к ОС для выполнения
                                       # системного вызова (вывода строки)

    /*** Дополнительные проверки - РЕАЛИЗУЙТЕ САМОСТОЯТЕЛЬНО ПО ЗАДАНИЮ */
    /* Проверяем поддерживается ли функция CPUID 1 */
        cmpl $1, -20(%ebp)
        jl no_cpuidone


    /* Проверка наличия математического сопроцессора (x87 FPU on Chip) */
        movl $1, %eax                  # загружаем код функции в регистр eax
        cpuid                          # получаем 

        test $0x00000001, %edx
        jz no_fpu

    /*** */


    /* x87 FPU on Chip имеется*/
    fpu:
        movl $4, %eax                  # помещаем номер системного вызова
                                       # write в регистр eax
        movl $1, %ebx                  # помещаем номер стандартного потока 
                                       # вывода (stdout) в ebx
        leal hasfpu, %ecx             # помещаем адрес начала буфера вывода
        movl $20, %edx                 # помещаем длину строки в edx
        int $0x80                      # обращаемся к ОС для выполнения
                                       # системного вызова (вывода строки)
        jmp mmx

    /* x87 FPU on Chip Отсутствует*/
    no_fpu:
        movl $4, %eax                  # помещаем номер системного вызова
                                       # write в регистр eax
        movl $1, %ebx                  # помещаем номер стандартного потока 
                                       # вывода (stdout) в ebx
        leal hasfpu, %ecx             # помещаем адрес начала буфера вывода
        movl $23, %edx                 # помещаем длину строки в edx
        int $0x80                      # обращаемся к ОС для выполнения
                                       # системного вызова (вывода строки)


    /* Проверка наличия подсистемы MMX */
    mmx:
        movl $1, %eax                  # загружаем код функции в регистр eax
        cpuid                          # получаем 

        test $0x00800000, %edx
        jz no_mmx

        movl $4, %eax                  # помещаем номер системного вызова
                                       # write в регистр eax
        movl $1, %ebx                  # помещаем номер стандартного потока 
                                       # вывода (stdout) в ebx
        leal hasmmx, %ecx             # помещаем адрес начала буфера вывода
        movl $8, %edx                 # помещаем длину строки в edx
        int $0x80                      # обращаемся к ОС для выполнения
                                       # системного вызова (вывода строки)
        jmp done

    no_mmx:
        movl $4, %eax                  # помещаем номер системного вызова
                                       # write в регистр eax
        movl $1, %ebx                  # помещаем номер стандартного потока 
                                       # вывода (stdout) в ebx
        leal hasnommx, %ecx             # помещаем адрес начала буфера вывода
        movl $11, %edx                 # помещаем длину строки в edx
        int $0x80                      # обращаемся к ОС для выполнения
                                       # системного вызова (вывода строки)
        jmp done



    /* Обработка ситуации, если cpuid 1 отсутствует */
    no_cpuidone:
        movl $4, %eax                  # помещаем номер системного вызова
                                       # write в регистр eax
        movl $1, %ebx                  # помещаем номер стандартного потока 
                                       # вывода (stdout) в ebx
        leal nocpuidone, %ecx             # помещаем адрес начала буфера вывода
        movl $34, %edx                 # помещаем длину строки в edx
        int $0x80                      # обращаемся к ОС для выполнения
                                       # системного вызова (вывода строки)
        jmp done



    /* Обработка ситуации, если cpuid отсутствует (80386) */
    no_cpuid:
        movl $4, %eax                  # помещаем номер системного вызова
                                       # write в регистр eax
        movl $1, %ebx                  # помещаем номер стандартного потока 
                                       # вывода (stdout) в ebx
        leal errmess, %ecx             # помещаем адрес начала буфера вывода
        movl $24, %edx                 # помещаем длину строки в edx
        int $0x80                      # обращаемся к ОС для выполнения
                                       # системного вызова (вывода строки)

    /* Организуем корректное завершение программы */
    done:
        mov %ebp, %esp                  # восстанавливаем контекст стека
        popl %ebp

        movl $1, %eax                   # загружаем в eax номер вызова exit
        movl $0, %ebx                   # загружаем в ebx код возврата 0
        int $0x80                       # выполняем обращение к ОС для
                                        # выполнения системного вызова

.end                                    # последняя строка исходного текста  
