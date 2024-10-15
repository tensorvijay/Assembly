;For Assembly x64 Linux

section .data
    numbers db 2, 12, 0, 3, 8, 98, 69
    len equ $ - numbers
    newline db 0xa
    comma db ','

section .bss
    buffer resb 4

section .text
    global _start

_start:
    mov rcx, len
    dec rcx
    
outer_loop:
    push rcx
    mov rsi, numbers
    
inner_loop:
    mov al, [rsi]
    cmp al, [rsi+1]
    jle next
    
    ; Swap
    xchg al, [rsi+1]
    mov [rsi], al
    
next:
    inc rsi
    loop inner_loop
    
    pop rcx
    loop outer_loop
    
    ; Print sorted array
    mov r12, 0  ; counter
    
print_loop:
    movzx rax, byte [numbers + r12]
    
    ; Convert number to ASCII
    mov rdi, buffer
    call itoa
    
    ; Print number
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 4  ; maximum 3 digits + null terminator
    syscall
    
    ; Print comma or newline
    inc r12
    cmp r12, len
    je print_newline
    
    mov rax, 1
    mov rdi, 1
    mov rsi, comma
    mov rdx, 1
    syscall
    
    jmp continue_print
    
print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    jmp exit
    
continue_print:
    cmp r12, len
    jl print_loop
    
exit:
    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

; Function to convert integer to ASCII
; Input: RAX = integer to convert
;        RDI = pointer to output buffer
itoa:
    add rdi, 3
    mov byte [rdi], 0
    mov rcx, 10
    
.loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .loop
    
    ret
