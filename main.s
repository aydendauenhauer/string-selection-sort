;******************** (C) Ayden Dauenhauer *******************************************
; @file    HW7 Problem 2
; @author  Ayden Dauenhauer
; @date    2023
;*************************************************************************************

	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
	
			ldr		r0, =strarray	; Pointer to array of string pointers
			ldr		r1, =7			; Number of pointers in strarray
			bl		mysort			; Call sorting routine
endless		b		endless

		ENDP

mysort		PROC
			push 	{lr}			;Stores the return address
			mov 	r2, r0			;Copies the array address to r2 to be changed later
loop1		sub		r1, r1, #1		;Decrements the count
			mov		r7, r1			;Second counter for iterating the compare
			mov		r3, r2			;Set the start of the range
			mov		r4, r3			;Set to the next address part 1
			add		r4, r4, #4		;Set to the next address part 2
			bl		compare_and_swap
			bx		lr
			ENDP

compare_and_swap	PROC
compareloop	ldr		r5, [r3]		;Loads the first value into r5
			ldr		r6, [r4]		;Loads the next value into r6
			ldrb 	r8, [r5], #1	;Loads the first character of r5 into r8 and increments by 1 byte
			ldrb 	r9, [r6], #1	;Loads the first character of r6 into r9 and increments by 1 byte
			cmp		r8, r9			;Compares the first letters
			beq		isequal			;If the letters are equal then go to the next letter
done		;Should reach this line once the compared letters are different
			bgt		nextsmaller		;If r8>r9 then keep r4 and compare to the next number
			add		r4, r4, #4;		;Go to the next value
			sub		r7, r7, #1		;Decrement the count
			cmp		r7, #0			;Check if it's at the end of the list
			bgt		compareloop		;If not, then keep comparing
done2		;After reaching this line, the smallest value's address should be in r3 and the value in r5
			ldr		r5, [r3]		;Load the smallest number into r5
			ldr		r6, [r2]		;Load the address into r6
			str		r5, [r2]		;Store the address
			str		r6, [r3]		;Store the smallest number
			add		r2, r2, #4		;Go to the next address
			cmp		r1, #1			;Check if it's at the end of the list
			bgt		loop1			;If not then start the whole proccess over
			pop		{pc}			;If done, then return

isequal		push 	{lr}
			ldrb 	r8, [r5], #1	;Loads the next character of r5 into r8 and increments by 1 byte
			ldrb 	r9, [r6], #1	;Loads the next character of r6 into r9 and increments by 1 byte
			cmp		r8, r9			;Compares the letters
			beq		isequal			;If the letters are equal then go to the next letter until they are different
			b		done
			
			
			bx		lr

nextsmaller	mov		r3, r4			;Swap the smallest number address into r3
			add		r4, r4, #4;		;Go to the next value
			sub		r7, r7, #1		;Decrement the count
			cmp		r7, #0			;Check if it's at the end of the list
			bgt		compareloop		;If not, then keep comparing
			b		done2
			
			bx		lr
			ENDP
						
			ALIGN
			AREA mydata, DATA, READONLY
				
strarray	DCD	str1, str2, str3, str4, str5, str6, str7
	
	
str1 		DCB "Andrew",0
str2 		DCB "aardvark",0
str3 		DCB "airplanes",0
str4 		DCB "America",0
str5 		DCB "air ball",0
str6 		DCB "Air Canada",0
str7 		DCB "airplane",0
		END