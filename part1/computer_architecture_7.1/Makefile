task7: main.c SumNumbers.o PrintResult.o
	gcc -m32 -gstabs+ -o task7 main.c SumNumbers.o PrintResult.o
SumNumbers.o:
	as --32 -gstabs+ -o SumNumbers.o SumNumbers.S
PrintResult.o:
	as -ahlsm=task7.lst --32 -gstabs+ -o PrintResult.o PrintResult.S
clean:
	rm *.o task7
