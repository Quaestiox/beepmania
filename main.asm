section .data

window_width dq 800
window_height dq 600

name: db "Beep!",0
combo: db "Combo:",0

FPS dd 60

text_x dd 350
text_y dd 45
text_size dd 20

note1_x dd 200
note1_y dd 100
note1_width dd 80
note1_height dd 40

bar1_x dd 200
bar1_y dd 100
bar1_width dd 80
bar1_height dd 400

space dd 10

color_green db  0,255,0,255
color_white db 255,255,255,255
color_black db 0,0,0,255
color_red db 255,0,0,255


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

main_loop:
	
	call WindowShouldClose
	test rax, rax
	jnz .done 

	mov eax, [note1_y]
	add eax, 2
	mov [note1_y], eax	

	call BeginDrawing

	mov rdi, [color_black]
	call ClearBackground

    mov rdi, combo
    mov rsi, [text_x]
    mov rdx, [text_y]
    mov rcx, [text_size]
    mov r8, [color_white]
    call DrawText	; 绘制Combo

	mov r15, 0
	mov r14, [bar1_width]
	mov r13, [bar1_x]
.draw_bars:			; 绘制轨道
	test r15, r15
	jz .draw_bars_step2
	add r13, r14

.draw_bars_step2:

	mov rdi, r13
    mov rsi, [bar1_y]
    mov rdx, [bar1_width]
    mov rcx, [bar1_height]
    mov r8, [color_red]
    call DrawRectangle	
	inc r15
	cmp r15, 4
	jne .draw_bars


    mov rdi, [note1_x]
    mov rsi, [note1_y]
    mov rdx, [note1_width]
    mov rcx, [note1_height]
    mov r8, [color_green]
    call DrawRectangle	; 绘制note

	call EndDrawing
	jmp main_loop

.done:
	call CloseWindow
	mov rax, 60
	xor rdi, rdi
	syscall



;.draw_combo:
;	call BeginDrawing
	mov rdi, combo
	mov rsi, [text_x]
	mov rdx, [text_y]
	mov rcx, [text_size]
	mov r8, [color_white]
	call DrawText
;	call EndDrawing
	ret	

;.draw_note:
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


