section .data

window_width dq 1080
window_height dq 900

name: db "Beep!",0
score_text: db "Score:",0

format: db "%i",0

FPS dd 60


CreateTime dq 15
CreateTime_const dq 15

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

space dd 20

color_green db  0,255,0,255
color_white db 255,255,255,255
color_black db 0,0,0,255
color_red db 255,0,0,255
color_gray db 130,130,130,100

key_s dd 83
key_d dd 68
key_k dd 75
key_l dd 76

speed dq 5

note_count: dq 0
note_size: dq 0
judge: dd 30

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


	xor rdx, rdx
	mov r15, 0
	mov r14, 0
	mov r10, 0
.key_pressed_check:

   	mov edi, [key_s+r14]
	call IsKeyPressed
	cmp rax, 1
	jne .key_pressed_check_step2

	mov r13, [note_count]
	mov r12, 0

.note_judge:
	mov ebx, [notelist+r12]
	mov ecx, [note1_x]; 轨道判断
	add ecx, r10d
	cmp ebx, ecx 
	jne .note_judge_step3

	mov eax, [notelist+r12+4]	
	cmp eax, 750
	jl .negative
	sub eax, 750
	cmp eax, [judge]
	jl .note_judge_step2
	jmp .note_judge_step3
.negative:
	mov ebx, 750
	sub ebx, eax
	cmp ebx, [judge]
	jl .note_judge_step2
	jmp .note_judge_step3

.note_judge_step2:
	mov eax, [score]
	add eax, 100
	mov [score], eax
	mov eax, [color_black]
	mov [notelist+r12+12], eax

.note_judge_step3:
	add r12, 16
	sub r13, 1
	cmp r13, 0
	jne .note_judge
	

.key_pressed_check_step2:
	add r10d, [note1_width]
	add r14, 4
	add r15, 1
	cmp r15, 4
	jne .key_pressed_check


	jmp .no_key


.no_key:
	call EndDrawing

	mov rax, [note_count] ; 超过1000notes停止生成
	cmp rax, 1000
	je .next


	mov rax, [CreateTime] ; note生成间隔
	sub rax, 1
	mov [CreateTime], rax
	cmp rax, 1
	jne .next
	mov rax, [CreateTime_const]
	mov [CreateTime], rax

	mov rdi, 0
	mov rsi, 3
	call GetRandomValue
	mov r15, rax
	mov r14, [note_count]
	mov r13, [note_size]
	mov rax, [note1_width]
	mov rbx, r15
	mul rbx
	mov r12, rax

.create_notes:
	mov eax, [note_x]
	add eax, r12d
	mov [notelist+r13], eax
	mov eax, [note_y]
	mov [notelist+r13+4], eax
	mov eax, [note_w]
	mov [notelist+r13+8], eax
	mov eax, [note_h]
	mov [notelist+r13+12], eax
	add r13, 16
	mov [note_size],r13
	add r14, 1
	mov [note_count], r14

.next:
	mov r15, [note_count]

	cmp r15, 0
	je .next2

	mov r14, 0
.draw_notes:  ; 遍历数组
	mov edi, [notelist+r14]
	mov esi, [notelist+r14+4]
	mov edx, [notelist+r14+8]
	mov ecx, [notelist+r14+12]
	mov r8,  [color_green]
	call DrawRectangle
	mov eax, [notelist+r14+4]
	add eax, [speed]	; note 下落速度
	mov [notelist+r14+4], eax
	


	add r14, 16

	sub r15, 1
	cmp r15, 0
	jne .draw_notes

.next2:

	jmp main_loop

.done:
	call CloseWindow
	mov rax, 60
	xor rdi, rdi
	syscall



