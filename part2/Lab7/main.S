.code16
.global init

init:
    mov $menu, %si # loads the address of menu into si
    mov $0xe, %ah # loads 0xe (function number for int 0x10) into ah

print_menu_by_char:
    lodsb # loads the byte from the address in si into al and increments si
    cmp $0, %al # compares content in AL with zero
    je select_item # if al == 0, go to "done"
    int $0x10 # prints the character in al to screen
    jmp print_menu_by_char # repeat with next byte

select_item:
    mov $0, %ah # Get char from keyboard
    int $0x16

    cmpb $'3', %al  # If typed char code > code of "3"
    ja select_item
    cmpb $'1', %al	# If typed char code < code of "1"
    jb select_item

    mov $preparing, %si
    mov $0xe, %ah

print_preparing_by_char:
    lodsb
    cmp $0, %al
    je wait_preparing
    int $0x10
    jmp print_preparing_by_char

wait_preparing:
    #sub %cx, %cx
    #sub %dx, %dx
    #pusha
    mov $0x86, %ah
    mov $0x001e, %cx
    mov $0x8480, %dx
    mov $0, %al
    int $0x15
    #popa

    mov $ready, %si
    mov $0xe, %ah

print_ready_by_char:
    lodsb
    cmp $0, %al
    je wait_ready
    int $0x10
    jmp print_ready_by_char

wait_ready:
    #sub %cx, %cx
    #sub %dx, %dx
    #pusha
    mov $0x86, %ah
    mov $0x001e, %cx
    mov $0x8480, %dx
    mov $0, %al
    int $0x15
    #popa

    jmp init

    #mov $0xe, %ah # Print typed char to terminal
    #int $0x10
    #hlt # stop execution

menu: .asciz "Choose a drink:\n\r\t1.Tea \n\r\t2.Coffee \n\r\t3.Water\n\r"
preparing: .asciz "Making a drink...\n\r"
ready: .asciz "The drink is ready\n\r"

.fill 510-(.-init), 1, 0
.word 0xaa55
