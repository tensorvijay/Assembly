section .data
    num1 dq 5                   ; First number (5)
    num2 dq 11                  ; Second number (10)
    result dq 0                 ; Variable to store the result
    result_msg db 'Result: ', 0  ; Message to display before the result
    newline db 10, 0            ; Newline character

section .bss
    result_str resb 20          ; Buffer for storing the result as a string

section .text
    global _start

_start:
    ; Load the two numbers into registers
    mov rax, [num1]            ; Load num1 into RAX
    mov rbx, [num2]            ; Load num2 into RBX

    ; Perform the addition
    add rax, rbx               ; RAX = RAX + RBX

    ; Store the result
    mov [result], rax          ; Store the sum in the 'result' variable

    ; Convert result to string
    mov rdi, result_str        ; Destination for the string
    mov rsi, rax               ; The number to convert
    call int_to_ascii          ; Call the helper function to convert the integer to a string

    ; Print the message "Result: "
    mov rax, 1                 ; sys_write system call
    mov rdi, 1                 ; File descriptor (stdout)
    mov rsi, result_msg        ; Address of the message
    mov rdx, 8                 ; Length of the message
    syscall                    ; Call the kernel

    ; Print the result (converted string)
    mov rax, 1                 ; sys_write system call
    mov rdi, 1                 ; File descriptor (stdout)
    mov rsi, result_str        ; Address of the result string
    mov rdx, 20                ; Max length of the result
    syscall                    ; Call the kernel

    ; Print a newline
    mov rax, 1                 ; sys_write system call
    mov rdi, 1                 ; File descriptor (stdout)
    mov rsi, newline           ; Address of the newline character
    mov rdx, 1                 ; Length (just one byte for newline)
    syscall                    ; Call the kernel

    ; Exit the program
    mov rax, 60                ; Exit system call number
    xor rdi, rdi               ; Exit status 0
    syscall                    ; Call the kernel

; Helper function to convert a number in RAX to a string in RDI
int_to_ascii:
    mov rcx, 10                ; Divisor (10 for decimal)
    mov rbx, rdi               ; Save RDI (destination address)
    add rbx, 19                ; Move to the end of the buffer
    mov byte [rbx], 0          ; Null-terminate the string

convert_loop:
    xor rdx, rdx               ; Clear RDX for division
    div rcx                    ; Divide RAX by 10, quotient in RAX, remainder in RDX
    add dl, '0'                ; Convert the remainder to ASCII
    dec rbx                    ; Move the pointer backward
    mov [rbx], dl              ; Store the ASCII character
    test rax, rax              ; Check if quotient is 0
    jnz convert_loop           ; If not, continue converting

    mov rdi, rbx               ; Update RDI to point to the result string
    ret
