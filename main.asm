format ELF64 executable 3

segment readable executable

entry $
        mov     rax, buf
        mov     rdi, 1234
        call    uitoa

        ;mov     rax, buf
        ;mov     rdi, 80
        ;call    read_console

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
; uitoa
; converts unsigned int to string (base 10)
; inputs:
;     rax : string buf
;     rdi : number to convert
; outputs:
;     rax : the number of digits of the string
uitoa:
        ; move string address into another register
        mov     rsi, rax        ; move string buffer to rsi
        
        ; copy our number into rax to count number of digits
        mov     rax, rdi

        ; handle the case where the number is zero
        cmp     rax, 0          ; compare the number to zero
        jnz     uitoa_convert_regular
        mov     byte [rsi], 48  ; set the first char to '0'
        inc     esi             ; move to next char
        mov     byte [rsi], 0   ; zero terminate the string
        mov     rax, 1          ; set the return num of digits
        jmp     uitoa_end
uitoa_convert_regular:
        mov     r10, 10        ; quotient

        ; count the number of digits required for conversion
        xor     rcx, rcx        ; counter for the number of digits
uitoa_loop:
        xor     rdx, rdx        ; make sure the remainder starts at 0
        div     r10             ; divide the number by 10
        inc     ecx             ; increment the count by 1
        cmp     rax, 0          ; compare rax to 0
        jnz     uitoa_loop

        ; inc ecx by 1 to move to zero terminator of string
        inc     ecx

        ; save the rcx value to return at the end of the func
        mov     r8, rcx

        ; set the pointer to buf to be rcx number of digits in
        add     rsi, rcx

        ; write the terminating zero to the string
        mov     byte [rsi], 0
        mov     rax, rdi        ; reset rax with the original number
        dec     ecx             ; dec the count since we set the terminating 0

        ; loop through the number and convert the string
uitoa_convert:
        xor     rdx, rdx        ; make sure the remainder starts at 0
        dec     rsi             ; move buffer to next char
        div     r10             ; divide by 10
        add     rdx, 48         ; convert digit to ascii char
        mov     byte [rsi], dl  ; move char to buf
        loopnz  uitoa_convert

        mov     rax, r8         ; return the num of digits
uitoa_end:
        ret


segment readable writeable

buf     rb      80
