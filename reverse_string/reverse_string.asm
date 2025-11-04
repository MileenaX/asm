global _start

section .data
    msg db "Enter your string: ", 0
    len_msg  equ $ - msg
    rev_msg db "Reserved: ", 0
    len_rev_msg  equ $ - rev_msg
    len_buf equ 101
    
section .bss
    buffer resb len_buf			;буффер для ввода строки
    
section .text

reverse_string:				;функция разворачивает строку с использованием стека, параметры rdi-указать на строку, rsi-длина строки
    push rbp				;сохраняем базовый указатель стека
    mov rbp, rsp			;устанавливаем новый базовый указатель

    mov rcx, 0				;счетчик цикла
    
;цикл записи в стек
push_loop:
    cmp rcx, rsi
    jge done_pushing
    
    mov al, [rdi + rcx]
    push rax
    inc rcx
    jmp push_loop
    
done_pushing:
    mov rcx, 0				;обнуление счетчика цикла

;цикл считывания из стека
pop_loop:
    cmp rcx, rsi
    jge done_reversing
    
    pop rax
    mov [rdi + rcx], al
    inc rcx
    jmp pop_loop
    
done_reversing:
    mov rsp, rbp
    pop rbp
    ret   
    

_start:
    ;вывод приглашения
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len_msg
    syscall
    
    cmp rax, 0			   ; проверяем, что значение больше нуля
    jl error_exit
    
    cmp rax, rdx		   ; проверяем, что значение равно длине строки
    jne error_exit
    
    ;чтение строки с клавиатуры
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, len_buf
    syscall
    
    cmp rax, 0			   ; проверяем, что значение больше нуля
    jl error_exit
    
    mov r12, rax 		   ;сохраняем длину считанной строки
    dec r12			   ;уменьшаем для исключения символа новой строки
    
    ;вызов функции reverse_string
    mov rdi, buffer
    mov rsi, r12
    call reverse_string
    
    ;вывод ответа
    mov rax, 1
    mov rdi, 1
    mov rsi, rev_msg
    mov rdx, len_rev_msg
    syscall

    cmp rax, 0			   ; проверяем, что значение больше нуля
    jl error_exit
    
    cmp rax, rdx		   ; проверяем, что значение равно длине строки
    jne error_exit

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r12
    syscall
  
    cmp rax, 0			   ; проверяем, что значение больше нуля
    jl error_exit
    
    cmp rax, rdx		   ; проверяем, что значение равно длине строки
    jne error_exit    
    
    ;завершение программы
    mov rax, 0
    mov rdi, 0
    syscall
    
error_exit:			   ;обработка ошибки
    mov rax, 60		           
    mov rdi, 1			   ;код возврата -1 (ошибка)
    syscall
    

    
    
