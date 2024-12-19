section .data

window_width dq 1080
window_height dq 900

name: db "Beep!",0
score_text: db "Score:",0

format: db "%i",0

FPS dd 60

score dd 0
score_x dd 608
score_y dd 40
score_size dd 30


text_x dd 500
text_y dd 40
text_size dd 30

note1_x dd 330
note1_y dd 150
note1_width dd 100
note1_height dd 40

bar1_x dd 330
bar1_y dd 150
bar1_width dd 100
bar1_height dd 600

space dd 10

color_green db  0,255,0,255
color_white db 255,255,255,255
color_black db 0,0,0,255
color_red db 255,0,0,255
color_gray db 130,130,130,100

key_s dd 83
key_d dd 68
key_k dd 75
key_l dd 76

note_count: dd 0
note_size: dq 0

note_x: dd 330
note_y: dd 150
note_w: dd 100
note_h: dd 40


section .bss

notelist: resd 4000

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
	extern GetKeyPressed
	extern IsKeyDown
	extern IsKeyPressed
	extern TextFormat
	extern GetRandomValue

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

    mov rdi, score_text
    mov rsi, [text_x]
    mov rdx, [text_y]
    mov rcx, [text_size]
    mov r8, [color_white]
    call DrawText	; 绘制分数


	mov rdi, format
	mov rsi, [score]
	call TextFormat
	mov rdi, rax
    mov rsi, [score_x]
    mov rdx, [score_y]
    mov rcx, [score_size]
    mov r8, [color_white]
    call DrawText	; 绘制数字

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
    mov r8, [color_gray]
    call DrawRectangle	
	inc r15
	cmp r15, 4
	jne .draw_bars


   	mov edi, [key_s]
	call IsKeyPressed
	cmp rax, 1
	je .key_1


	mov edi, [key_d]
	call IsKeyPressed
	cmp rax, 1
	je .key_2

	jmp .no_key

.key_1: 
	mov eax, [score]
	add eax, 100
	mov [score], eax
	jmp .no_key

.key_2:
	mov rdi, 1
	mov rsi, 4
	call GetRandomValue
	mov [score], eax


	jmp .no_key


.no_key:
	call EndDrawing


	mov rdi, 1
	mov rsi, 4
	call GetRandomValue
	mov r15, rax
	mov r14, [note_count]
	mov r13, [note_size]
.create_notes:
	mov eax, [note_x]
	mov [notelist+r13], eax
	mov eax, [note_y]
	mov [notelist+r13+4], eax
	mov eax, [note_w]
	mov [notelist+r13+8], eax
	mov eax, [note_h]
	mov [notelist+r13+12], eax
	add r13, 16
	mov [note_size],r13


	mov r15, [note_count]
.draw_notes:



	jmp main_loop

.done:
	call CloseWindow
	mov rax, 60
	xor rdi, rdi
	syscall



