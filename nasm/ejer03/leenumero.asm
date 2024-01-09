section .data
	userMsg1 db "ingrese numero: ", 0xA, 0xD
	len1 equ $ - userMsg1
	userMsg2 db "ingrese otro numero: ", 0xA, 0xD
	len2 equ $ - userMsg2
	dispRes db "resultado de la suma: ", 0xA, 0xD
	len3 equ $ - dispRes

section .bss
	num1 resb 5
	num2 resb 5
	res resb 5

section .text
	global _start

_start:
	;impresion del userMsg1
	mov eax, 4
	mov ebx, 1
	mov ecx, userMsg1
	mov edx, len1
	int 0x80

	;lectura desde el teclado
	mov eax, 3
	mov ebx, 2
	mov ecx, num1
	mov edx, 5
	int 0x80

	;impresion del userMsg2
	mov eax, 4
	mov ebx, 1
	mov ecx, userMsg2
	mov edx, len2
	int 0x80

	;lectura desde el teclado
	mov eax, 3
	mov ebx, 2
	mov ecx, num2
	mov edx, 5
	int 0x80

	;calculating add op
	mov eax, [num1]
	sub eax, '0'
	mov ebx, [num2]
	sub ebx, '0'
	add eax, ebx
	add eax, '0'
	mov [res], eax

	;printing result message
	mov eax, 4
	mov ebx, 1
	mov ecx, dispRes
	mov edx, len3
	int 0x80

	;printing add result
	mov eax, 4
	mov ebx, 1
	mov ecx, res
	mov edx, 5
	int 0x80

	;cierre del programa/closing program
mov eax, 1
int 0x80


