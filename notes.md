A.2.1 Calling Conventions
Arguments are put in the registers rdi, rsi, rdx, rcx, r8 and r9, in that order.
The system is called with the syscall instruction. The kernel destroys registers %rcx and %r11.
The number of the syscall has to be passed in register %rax.
The return value of the system call is in rax. An error is signalled by returning -errno.

grep -rl "#define SOCK_STREAM" /usr/include/
syscall
errno

