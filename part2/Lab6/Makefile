bmp : bmp_io.o inout.o bmp_copy.o bmp_gray.o bmp_gray2.o bmp_gray3.o bmp_sepia.o
	gcc -m32 bmp_io.o inout.o bmp_copy.o bmp_gray.o bmp_gray2.o bmp_gray3.o bmp_sepia.o -o bmp

bmp_io.o : bmp_io.c
	gcc -m32 -c bmp_io.c -o bmp_io.o

bmp_copy.o : bmp_copy.c
	gcc -m32 -c bmp_copy.c -o bmp_copy.o

bmp_gray.o : bmp_gray.c
	gcc -m32 -c bmp_gray.c -o bmp_gray.o

bmp_sepia.o : bmp_sepia.c
	gcc -m32 -c bmp_sepia.c -o bmp_sepia.o

bmp_gray2.o : bmp_gray2.c
	gcc -m32 -c bmp_gray2.c -o bmp_gray2.o

bmp_gray3.o : bmp_gray3.S
	as --32 -gstabs+ -o bmp_gray3.o bmp_gray3.S

inout.o : inout.c
	gcc -m32 -c inout.c -o inout.o

clean :
	rm *.o bmp