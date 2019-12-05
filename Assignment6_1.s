/*****************************************
 File: Assignement part2.s
 Author: Pavan Kumar G
 Roll number: CS18M517
 Guide: Prof. Madhumutyam IITM, PACE
******************************************/

/*
Assignment 6.1: program for searching a given integer number in an array of integer numbers(SORTED)
Implementd using Binary search algorithm with Complexity is O(n)

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

            LDR R7, =InArray;                 @ R7 <--starting address of array

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
            STMFD SP!, {R5, LR};
            EOR R0, R0, R0;			@ to store final output in R0
LOOPS:       LDR R5, [R7], #4;               @Traverse all the elements 
            ADD R0, R0, #1                  
            CMP R5, R6;                     @If element found, break the loop
            BEQ DONE;
            SUBS R2, R2, #1;                
            BNE LOOPS;
            MOV R0, #-1;                    @If number is not found, store -1
DONE:       LDMFD SP!, {R5, PC}             @Return to main program
