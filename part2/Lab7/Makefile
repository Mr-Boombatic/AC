all: boot.bin
remake: clean all

boot.bin: main.o
	ld -o boot.bin --oformat binary -e init -Ttext 0x7c00 -o boot.bin main.o

main.o: main.S
	as -o main.o main.S

clean:
	rm *.o boot.bin