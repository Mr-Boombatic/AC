main: ass main.o
	gcc -m32 -o main main.o math.o

main.o:
	gcc -m32 -c main.c

ass:
	as --32 math.s -o math.o

clean:
	rm *.o main
