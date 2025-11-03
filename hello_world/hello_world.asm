global _start                      ; делаем метку метку _start видимой извне
 
section .data                      ; секция данных
    message db  "Hello world!",10  ; строка для вывода на консоль
    length  equ $ - message
 
section .text                      ; объявление секции кода
_start:                            ; точка входа в программу
    mov rax, 1                     ; 1 - номер системного вызова функции write
    mov rdi, 1                     ; 1 - дескриптор файла стандартного вызова stdout
    mov rsi, message               ; адрес строки для вывод
    mov rdx, length                ; количество байтов
    syscall                        ; выполняем системный вызов write
    
    cmp rax, 0			   ; проверяем, что значение больше нуля
    jl error_exit
    
    cmp rax, rdx		   ; проверяем, что значение равно длине строки
    jne error_exit
 
    mov rax, 60                    ; 60 - номер системного вызова exit
    mov rdi, 0
    syscall                        ; выполняем системный вызов exit
   
error_exit:			   ;обработка ошибки
    mov rax, 60		           
    mov rdi, 1			   ;код возврата -1 (ошибка)
    syscall
