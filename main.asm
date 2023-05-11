format ELF64 executable 3

segment readable executable

entry $
        mov     rax, buf
        mov     rdi, 80
        call    read_console

        mov     rdi, rax        ; num bytes to write
        mov     rax, buf        ; buf addr
        call    write_console

        ; exit the program
        xor     rdi, rdi        ; exit code
        mov     rax, 60         ; sys_exit
        syscall

; write_console
; writes outputs from buffer to stdout
; inputs:
;     rax : buf addr
;     rdi : buf size
; outpus:
;     rax : number of bytes written (-1 if error)
write_console:
        mov     rsi, rax        ; buffer addr
        mov     rdx, rdi        ; buffer size

        ; read from stdin
        mov     rax, 1          ; buffer address
        mov     rdi, 1          ; buffer size
        syscall
        ret


; read_console
; reads input from stdin into a buffer
; inputs:
;     rax : buf addr
;     rdi : buf size
; outpus:
;     rax : number of bytes read (-1 if error)
read_console:
        mov     rsi, rax        ; buffer addr
        mov     rdx, rdi        ; buffer size

        ; read from stdin
        xor     rax, rax        ; buffer address
        xor     rdi, rdi        ; buffer size
        syscall
        ret

segment readable writeable

buf     rb      80
