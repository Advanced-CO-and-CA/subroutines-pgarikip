/*****************************************
 File: Assignement part2.s
 Author: Pavan Kumar G
 Roll number: CS18M517
 Guide: Prof. Madhumutyam IITM, PACE
******************************************/

/*
Assignment 6.2: program for searching a given integer number in an array of integer numbers(SORTED)
Implementd using Binary search algorithm with Complexity is O(LogN)

*/

/*
	Input	- Element to be searched & array
	Output 	- Return Position of element if found else -1 otherwise
 */


  @ BSS section
      .bss


.data

	.equ SWI_PrStr, 0x69 ; @Write a string to file handle
	.equ SWI_RdInt, 0x6c ; @Read an integer from file handle
	.equ SWI_PrInt, 0x6b ; @Write an integer to file handle
	.equ SWI_Exit, 0x11 @ Stop execution

	infHandle: .word 0x00;
	opfHandle: .word 0x01;
	numSearch:   .asciz "\nEnter element to be searched:-\n"
	arrlenRequest:   .asciz "Enter array length -\n"
	InSingleEleMsg: .asciz "Enter the element:- "
	arrMsg:   .asciz "\nEnter array elements\n"
	arrMsg2:   .asciz "\n Reading of elements completed\n"
	FinalOutput: .asciz "The number's position in the array is- \n"

.align
InArray: .word 0x00;
Output: .word 0x00;

	

	

.text
.global main

main:

            LDR R1, =opfHandle;         @Handle to stdout
            LDR R0, [R1];
            LDR R1, =arrlenRequest;
            SWI SWI_PrStr;
			
            LDR R0, =infHandle;          @Handle to stdin
            LDR R0, [R0];
            SWI SWI_RdInt;
            MOV R2, R0;                     @array length --> R2

            LDR R1, =opfHandle;         
            LDR R0, [R1];
            LDR R1, =arrMsg;
            SWI SWI_PrStr;
                    
            MOV R3, R2;                     
            LDR R8, =InArray;                 @Traverse array elements one by one
LOOP:       
			LDR R1, =opfHandle;         @Handle to stdout
            LDR R0, [R1];
            LDR R1, =InSingleEleMsg;
			SWI SWI_PrStr;
			
			LDR R0, =infHandle;
            LDR R0, [R0];
            SWI SWI_RdInt;
            STR R0, [R8],#4;   @Storing the elements to memory
           
			
            SUBS R3, R3, #1;                
            BNE LOOP;        @Read All elements
			
			LDR R1, =opfHandle;         @Handle to stdout
            LDR R0, [R1];
            LDR R1, =arrMsg2;
			SWI SWI_PrStr;
			
            LDR R1, =opfHandle;         @enter number to be searched to stdout
            LDR R0, [R1];
			
            LDR R1, =numSearch;
            SWI SWI_PrStr;
			
            LDR R0, =infHandle;          @input from stdin
            LDR R0, [R0];
			
            SWI SWI_RdInt;
            MOV R6, R0;                     @Search element in R6

            LDR R3, =InArray;                 @ R7 <--starting address of array

            BL SEARCH;                      @Call subroutine SEARCH
            LDR R1, =Output;
            STR R0, [R1];
            MOV R8, R0;                     @Register R8 has the output

            LDR R1, =opfHandle;         @Printing result to stdout
            LDR R0, [R1];
            LDR R1, =FinalOutput;                     
            SWI SWI_PrStr;
            LDR R1, =opfHandle;
            LDR R0, [R1];
            MOV R1, R8;                                   
            SWI SWI_PrInt;
            SWI SWI_Exit;                   @Stop the program


SEARCH: 
            STMFD SP!, {R1, R5-R8, LR};
            EOR R5, R5, R5;                 @r5 <-- 0 Min
            MOV R6, R2;                   @ Max
            SUB R6, R6, #1;                @ n-1 
            MOV R7, #4;

LOOPS:      SUBS R8, R6, R5;                @Calculating the mid index (max - min)/2+ min
            BEQ SKIP;                       
            BLT FAIL;              @If min < max, NUM NOT PRESENT

            MOV R8, R8, LSR #1;             
            ADD R1, R8, R5;                 @Add to min -> (max - min)/2+ min --> R1

SKIP:       MOV R0, R1;                     
            ADD R0, R0, #1;                @ final output 
            MUL R8, R7, R1;                 @ base address = index * alignmnt (4)
            ADD R8, R3, R8;
            LDR R9, [R8];                   @Load the array element at mid index
            
            CMP R4, R9;                     @Compare element to be searched with this mid element
            BEQ DONE;                       
            BLT LESS;                       @If number is lesser look in  first half of the array
            
			ADD R1, R1, #1;                 @new min index  is mid index + 1
            MOV R5, R1;            
            B LOOPS;
LESS:            
            SUB R1, R1, #1;                 @new max index  is mid index -1
            MOV R6, R1;
            B LOOPS;

          

FAIL:  MOV R0, #-1;                    @If not found, store -1                   
                       
DONE:       LDMFD SP!, {R1, R5-R8, PC}      @Return to main program by restoring registers
