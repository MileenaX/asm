global _start                      ; делаем метку метку _start видимой извне
 
section .data                      ; секция данных
    message db  "Hello world!",10  ; строка для вывода на консоль
    length  equ $ - message
    
    filename db "output.txt", 0    ; имя файла

section .bss
    file_descriptor resq 1	   ; место для хранения файлового дескриптора

section .text                      ; объявление секции кода
_start:                            ; точка входа в программу
    mov rax, 2			   ; системный вызов open
    mov rdi, filename		   ; имя файла
    mov rsi, 577		   ; Флаги: O_WRONLY | O_CREAT | O_TRUNC (1 | 64 | 512 = 577)
    mov rdx, 0o666		   ; Права доступа к файлу
    syscall
    
    cmp rax, 0			   ; Проверка успешного открытия файла
    jl error_exit
   
    mov [file_descriptor], rax     ; Сохранение файлового дескриптора
   
    mov rax, 1                     ; 1 - номер системного вызова функции write
    mov rdi, [file_descriptor]                     ; дескриптор файла 
    mov rsi, message               ; адрес строки для вывод
    mov rdx, length                ; количество байтов
    syscall                        ; выполняем системный вызов write
    
    cmp rax, 0			   ; проверяем, что значение больше нуля
    jl error_exit
    
    cmp rax, rdx		   ; проверяем, что значение равно длине строки
    jne error_exit
 
    mov rax, 3			   ; системный вызов close, закрываем файл
    mov rdi, [file_descriptor]
    syscall
 
    mov rax, 60                    ; 60 - номер системного вызова exit
    mov rdi, 0
    syscall                        ; выполняем системный вызов exit
   
error_exit:			   ;обработка ошибки
    mov rax, 60		           
    mov rdi, 1			   ;код возврата -1 (ошибка)
    syscall
