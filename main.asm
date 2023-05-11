format ELF64 executable 3

segment readable executable

entry $
        ; read from stdin
        xor     rax, rax        ; sys_read
        xor     rdi, rdi        ; stdin
        mov     rsi, buf        ; buffer address
        mov     rdx, 80
        syscall

        ; write to stdout
        mov     rax, 1          ; sys_write
        mov     rdi, 1          ; stdout
        ; rsi should still be address of buffer
        mov     rdx, 80
        syscall

        ; exit the program
        xor     rdi, rdi        ; exit code
        mov     rax, 60         ; sys_exit
        syscall

segment readable writeable

buf     rb 80
