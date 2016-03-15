;*********************************
; Dahv Reinhart
; V00735279
; CSC230 - Assignment 3
; 'Moving Message'
;*********************************
#define LCD_LIBONLY
.include "lcd.asm"

;.equ ADCSRA=0x7A
;.equ ADMUX=0x7C
;.equ ADCL=0x78
;.equ ADCH=0x79


.cseg
	call lcd_init
	call lcd_clr
	call init_strings
	call init_button


;***********************
	ldi r18 , 0x03
	ldi r19 , 0x02
	
do_3_times:

	ldi r16, 0x00
	push r16
	ldi r16, 0x00
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	ldi r17, 0x00

	call do_2_timesF
	ldi r19, 0x02
	ldi r17, 0x00
	;call do_2_timesR  [used for first draft of assignment: not needed anymore]
	;ldi r19 , 0x02 [no reassignment needed in second draft of assignment]

	dec r18
	brne do_3_times
	jmp finalA


do_2_timesF:

	call lcd_clr

	call display_line_1
	call half_sec
	call lcd_clr
	call display_line_2
	call half_sec
	
	inc r17
	
	dec r19
	brne do_2_timesF
	ret

do_2_timesR:

	call lcd_clr

	dec r17

	call display_line_1
	call half_sec
	call lcd_clr
	call display_line_2
	call half_sec

	dec r19
	brne do_2_timesR
	ret
	
;***********************

init_strings:
	push r16
	; copy strings from program memory to data memory
	ldi r16, high(msg1)		; this the destination
	push r16
	ldi r16, low(msg1)
	push r16
	ldi r16, high(msg1_p << 1) ; this is the source
	push r16
	ldi r16, low(msg1_p << 1)
	push r16
	call str_init			; copy from program to data
	pop r16					; remove the parameters from the stack
	pop r16
	pop r16
	pop r16

	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	ldi r16, high(msg2_p << 1)
	push r16
	ldi r16, low(msg2_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16

	ldi r16, high(msg3)
	push r16
	ldi r16, low(msg3)
	push r16
	ldi r16, high(msg3_p << 1)
	push r16
	ldi r16, low(msg3_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16

	pop r16
	ret

;*****************
;BUTTON STUFF
;*****************
init_button:
	ldi r25, 0x87
	sts 0x7A, r25
	ldi r25, 0x40
	sts 0x7C, r25
	ret

;*****************

check_button:
		; start a2d conversion
		lds	r25, 0x7A
		ori r25, 0x40
		sts	0x7A, r25

wait:	; wait for it to complete
		lds r25, 0x7A
		andi r25, 0x40
		brne wait

		; read the value
		lds r25, 0x78
		lds r26, 0x79

		ldi r24, 0
		cpi r26, 0
		brne skip
		ldi r24, 1		
		call stop_now
		
skip:	ret

;*****************
;BUTTON STUFF
;*****************

display_line_1:

	mov r16, r17
	push r16
	mov r16, r17
	push r16
	call lcd_gotoxy
	pop r16
	pop r16
	
	push r16
	; Now display msg1 on the first line
	ldi r16, high(msg1)
	push r16
	ldi r16, low(msg1)
	push r16
	call lcd_puts
	pop r16
	pop r16
	pop r16

	ret


display_line_2:

	mov r16, r17
	push r16
	mov r16, r17
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	push r16
	; Now display msg2 on the second line
	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	call lcd_puts
	pop r16
	pop r16
	pop r16

	ret



display_char:
	ldi r16, 0x00
	push r16
	ldi r16, 0x07
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	push r16
	; Now display msg3 on the second line
	ldi r16, high(msg3)
	push r16
	ldi r16, low(msg3)
	push r16
	call lcd_puts
	pop r16
	pop r16
	pop r16

	ret
;**********************

half_sec:
	ldi r24, 0
	call check_button
	cpi r24, 1
	breq stop_now

			ldi r20, 0x30
	del1:	nop
			ldi r21,0xFF
	del2:	nop
			ldi r22, 0xFF
	del3:	nop
			dec r22
			brne del3
			dec r21
			brne del2
			dec r20
			brne del1	
	ret

stop_now:
	ldi r24, 0
	call check_button
	cpi r24, 1
	brne stop_now
	ret

finalA:
	call lcd_clr
	call half_sec
	ldi r19, 0x03
	jmp finalB

finalB:
	
	call display_char
	call half_sec
	call lcd_clr
	call half_sec
	
	dec r19
	brne finalB
	jmp done


done: 
	call lcd_clr
	jmp done

msg1_p: .db "Fiona H. Albioni", 0
msg2_p: .db "CSC 230 Student!", 0
msg3_p: .db "A               ", 0

.dseg

	msg1: .byte 200
	msg2: .byte 200
	msg3: .byte 200

	line1: .byte 17
	line2: .byte 17

