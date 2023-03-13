section .data
BYTES_PER_ROW   dw	1800
check		dw	3
;x_pos [ebp-4]	
;y_pos [ebp-8]		
;direction [ebp-12]		
;n_move	[ebp-16]	
;pen_low[ebp-20]		
;color	[ebp-24]
max_y		dw      50
max_x 		dw	600
section .text
global func
func:

	push ebp
	mov	ebp, esp
	sub     esp, 24
	mov	eax, DWORD [ebp+8]
	mov	ebx, DWORD [ebp+12]
	mov	ecx, DWORD [ebp+16]
	dec 	ebx
	inc	ecx
	jmp loop




loop:	          
	mov dx, word[check] 		
	call new_byte
	call new_byte

	mov dx, [ebx]
	and dx, 3        
	cmp dx, 3
	je set_position  
	cmp dx, 2
	je set_direction 
	cmp dx, 1
	je move          
	cmp dx, 0
	je pen_state     
	jmp loop

set_position:
	jmp y_position
y_position:
	mov dl, [ebx]
	shr dl, 2
	mov word[ebp-8], dx
	cmp dx, word[max_y]           
	jg set_max_y       
	jmp x_position
set_max_y:
	mov dx, word[max_y]
	mov word[ebp-8], dx
	jmp x_position
x_position:
	call new_byte
	mov dl, [ebx]
	and dl, 3
	shl dx, 8
	mov word[ebp-4], dx
	call new_byte

	mov dl, [ebx]
	add word[ebp-4], dx
	mov dx, word[ebp-4]
	cmp dx, word[max_x]          
	jg set_max_y    
	jmp loop
set_max_x:
	mov dx, word[max_x]
	mov word[ebp-4], dx
	jmp loop
set_direction:
	call previous_byte
	mov dl, [ebx]
	shr dl, 6 
	call new_byte

	mov word[ebp-12], dx      
	jmp loop	
move:
	call previous_byte
	mov dl, [ebx]
	mov word[ebp-16], dx
	shl word[ebp-16], 2
	call new_byte

	mov dl, [ebx]
	shr dl, 6
	add word[ebp-16], dx
	mov dx, word[ebp-16]
	jmp move_loop

move_loop:
	dec word[ebp-16]
	cmp word[ebp-16], 0
	je loop
	cmp word[ebp-12], 3
	je move_down
	cmp word[ebp-12], 2
	je move_left
	cmp word[ebp-12], 1
	je move_up
	cmp word[ebp-12], 0
	je move_right

	
move_right:
	inc word[ebp-4]
	cmp word[ebp-20], 0
	je move_loop       
	call put_pixel
	jmp move_loop
move_up:
	inc word[ebp-8]
	cmp word[ebp-20], 0
	je move_loop  
	call put_pixel
	jmp move_loop
move_left:
	dec word[ebp-4]
	cmp word[ebp-20], 0
	je move_loop  
	call put_pixel
	jmp move_loop
move_down:
	dec word[ebp-8]
	cmp word[ebp-20], 0
	je move_loop  
	call put_pixel
	jmp move_loop
	
pen_state:
	mov dl, [ebx]
	and dl, 8
	shr dl, 3
	mov word[ebp-20], dx
	call previous_byte
	mov dl, [ebx]
	shl dx, 4
	mov word[ebp-24], dx
	call new_byte
	and dx, 0
	mov dl, byte[ebx]
	shr dl, 4
	add word[ebp-24], dx
	mov dx, word[ebp-24]
	jmp loop

previous_byte:
	dec ebx
	inc ecx
	ret
new_byte:
	inc ebx 
	dec ecx
	cmp ecx, 0
	jle exit

	ret

put_pixel:
	cmp word[ebp-4], 0
	jl loop
	cmp word[ebp-8], 0
	jl loop
	mov dx, word[max_x]
	cmp word[ebp-4], dx
	je loop
	mov dx, word[max_y]
	cmp word[ebp-8], dx
	je loop
	
	mov esi, eax
	add eax, 10
	mov edx, [eax]
	add eax, -10		
	add eax, edx        
	
	and edx, 0
	add edx, 1800
	imul edx, dword[ebp-8]          
	imul edi, dword[ebp-4], 3	        
	add edi, edx	        
	add eax, edi	        
	

	mov dx, word[ebp-24]
	shl dx, 4
	mov byte[eax], dl		
	shr dx, 8
	shl dx, 4
	mov byte[eax+1], dl			
	shr dx, 8
	shl dx, 4
	mov byte[eax+2], dl	
	mov eax, esi	
	ret

exit:	
	mov eax, 0
	mov esp, ebp
	pop	ebp
	ret


