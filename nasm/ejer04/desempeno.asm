section .data
	userMsg1 db "Dame un numero: ", 0xA, 0xD
	len1 equ $ - userMsg1
	dispRes1 db "El incremento es: ", 0xA, 0xD
	len2 equ $ - dispRes1
	dispRes2 db "El decremento es: ", 0xA, 0xD
	len3 equ $ - dispRes2

section .bss
	num1 resb 5
	res1 resb 5
	res2 resb 5

section .text
	global _start

_start:
	;impresion de userMsg1
	mov eax, 4
	mov ebx, 1
	mov ecx, userMsg1
	mov edx, len1
	int 0x80

	;lectura del teclado
	mov eax, 3
	mov ebx, 1
	mov ecx, num1
	mov edx, 5
	int 0x80

	;incremento
	mov eax, [num1]
	inc eax
	mov [res1], eax

	;comentario del incremento
	mov eax, 4
	mov ebx, 1
	mov ecx, dispRes1
	mov edx, len2
	int 0x80

	;imprimir incremento
	mov eax, 4
	mov ebx, 1
	mov ecx, res1
	mov edx, 5
	int 0x80

	;decremento
	mov eax, [res1]
	dec eax
	mov [res2], eax

	;comentario del decremento
	mov eax, 4
	mov ebx, 1
	mov ecx, dispRes2
	mov edx, len3
	int 0x80

	;imprimir decremento
	mov eax, 4
	mov ebx, 1
	mov ecx, res2
	mov edx, 5
	int 0x80

	mov eax, 1
	int 0x80

