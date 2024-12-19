section .data

window_width dq 800
window_height dq 600

name: db "Beep!",0
combo: db "Combo:",0

FPS dd 60

text_x dd 350
text_y dd 45
text_size dd 20

note1_x dd 100
note1_y dd 100
note1_width dd 50
note1_height dd 20

color_green db  0,255,0,255
color_white db 255,255,255,255
color_black db 0,0,0,255
section .bss


section .text
	global _start
	extern InitWindow
	extern WindowShouldClose
	extern CloseWindow
	extern BeginDrawing
	extern EndDrawing
	extern DrawRectangle
	extern WaitTime
	extern DrawText
	extern ClearBackground
	extern SetTargetFPS
_start:
	mov rdi, [window_width]
	mov rsi, [window_height]
	mov rdx, name
	call InitWindow
	mov rdi, [FPS]
	call SetTargetFPS

	call main_loop
	
	call CloseWindow

	mov rax, 60
	xor rdi, rdi
	syscall

main_loop:

	call WindowShouldClose
	test rax, rax
	jnz .done 

	call BeginDrawing
	call .draw_combo
	call .draw_note

	call EndDrawing
	call WaitTime
	jmp main_loop

.done:
	ret

.draw_combo:
;	call BeginDrawing
	mov rdi, combo
	mov rsi, [text_x]
	mov rdx, [text_y]
	mov rcx, [text_size]
	mov r8, [color_white]
	call DrawText
;	call EndDrawing
	ret	

.draw_note:
;	mov rax, [note1_y]
;	add rax, 1
;	mov [note1_y], rax

;	call BeginDrawing
;	mov rdi, [color_black]
;	call ClearBackground
	mov rdi, [note1_x]
	mov rsi, [note1_y]
	mov rdx, [note1_width]
	mov rcx, [note1_height]
	mov r8, [color_green]
	call DrawRectangle
;	call EndDrawing
	ret	


