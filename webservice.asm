global _start

segment .bss
    inputbuffer: resb 512
    glennbuffer: resb 28758

segment .text

;The system call number is put in rax.
;Arguments are put in the registers rdi, rsi, rdx, rcx, r8 and r9, in that order.
;The system is called with the syscall instruction.
;The return value of the system call is in rax.

;A system-call is done via the syscall instruction. The kernel destroys
;registers %rcx and %r11.

;The use of $ (current address)

;nasm -f elf64 webservice.asm; ld webservice.obj -o webservice

exit:
    mov rdi, rax
    mov rax, 60
    syscall

loadglenn:
    mov rax, 2
    mov rdi, glennpath
    mov rsi, 0
    syscall
    cmp rax, 0
    jle exit

    mov r12, rax
    mov rax, 0
    mov rdi, r12
    mov rsi, glennbuffer
    mov rdx, 28758
    syscall
    cmp rax, 28758
    jne exit

    mov rax, 3
    mov rdi, r12
    syscall

    ret

_start:
    call loadglenn

    ;fd = socket(AF_INET, SOCK_STREAM, 0);
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    syscall
    mov r9,rax ;r9 contains fd (return value)

    push dword 0      ; 4 bytes padding
    push dword 0      ; 4 bytes padding
    push dword 0      ; INADDR_ANY
    push word 0xd00d  ; port 3536
    push word 2       ; AF_INET

    ;bind(fd, *addr, addrlen)
    mov rax, 49
    mov rdi, r9
    mov rsi, rsp
    mov rdx, 16
    syscall
    cmp rax, 0
    jl exit

    add rsp, 16

    mov rax, 50
    mov rdi, r9
    mov rsi, 10
    syscall

loop:
    mov rax, 43
    mov rdi, r9
    mov rsi, 0
    mov rdx, 0
    syscall
    cmp rax, 0
    jl exit
    mov r12, rax ;r12 fd to client

    mov rax, 57
    syscall
    cmp rax, 0
    jne loop

    mov rax, 3
    mov rdi, r9
    syscall

    mov rax, 0
    mov rdi, r12
    mov rsi, inputbuffer
    mov rdx, 512
    syscall

    mov rax, 1
    mov rdi, r12
    mov rsi, msg
    mov rdx, msglen
    syscall

    mov rax, 1
    mov rdi, r12
    mov rsi, glennbuffer
    mov rdx, 28758
    syscall

    mov rax, 3
    mov rdi, r9
    syscall

segment .rodata
    ;msg: db `HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 13\r\nConnection: Close\r\n\r\nHello, world!`
    msg: db `HTTP/1.1 200 OK\r\nContent-Type: image/gif\r\nContent-Length: 28758\r\nConnection: Close\r\n\r\n`
    msglen: equ $ - msg ; current (next) address - address of msg
    glennpath: db "glenn.gif"