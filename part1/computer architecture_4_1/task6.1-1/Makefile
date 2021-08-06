task6.1-exe-S: fact.o
	ld -melf_i386 -o task6.1-exe-S fact.o
fact.o:
	as -ahlsm=task6.1.lst --32 -gstabs+ -o fact.o fact.S
clean:
	rm *.o task6.1-exe-S *.lst
remake: clean task6.1-exe-S
