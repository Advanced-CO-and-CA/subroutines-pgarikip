/*****************************************
 File: Assignement part3.s
 Author: Pavan Kumar G
 Roll number: CS18M517
 Guide: Prof. Madhumutyam IITM, PACE
******************************************/

/*
Assignment 6.3: program for findinding N fibonacci number for given input
Implementd using Recursive algorithm

*/

/*
	Input	- Sequence length N
	Output 	- Nth fibonacci number
 */



  @ BSS section
      .bss

  
  @ DATA SECTION
  .data
  
  InFileHandle: .word 0x00;
  OutFileHandle: .word 0x01;
  numReq:   .asciz "Enter a number N -\n"
  opMsg: .asciz "The Nth fibonacci number in the series is- \n"

  NUM: .word 0x00;
  .skip 4               @Skip 4 bytes to store the number N entered

  .align
  Output: .word 0x00    @Output Nth fibonacci number
  .equ SWI_PrStr, 0x69 ; @Write a string to file handle
  .equ SWI_RdInt, 0x6c ; @Read an integer from file handle
  .equ SWI_PrInt, 0x6b ; @Write an integer to file handle
  .equ SWI_Exit, 0x11    @Stop execution
 
  @ TEXT section
      .text

.globl _main


_main:
        LDR R1, =OutFileHandle;           @Request number N
        LDR R0, [R1];
        LDR R1, =numReq;         
        SWI SWI_PrStr;

        LDR R0, =InFileHandle;            @Read the number N input from stdin
        LDR R0, [R0];
        SWI SWI_RdInt;  
              
        SUB R0, R0, #2;                   
        MOV R4, R0;                       @Effetive lengthy N-2
        MOV R1, #1;        
        PUSH {R1};                        @Initial elements : 1 ,1
        PUSH {R1};
        BL FIBONACCI;                     @Calling the Fibonacci subroutine
        LDR R1, =Output;                  
        STR R0, [R1];
        MOV R2, R0;                       @Storing the result obtained in R2

        LDR R1, =OutFileHandle;           @Printing result to stdout
        LDR R0, [R1];
        LDR R1, =opMsg;
        SWI SWI_PrStr;
        LDR R1, =OutFileHandle;
        LDR R0, [R1];
        MOV R1, R2;                                   
        SWI SWI_PrInt;
        SWI SWI_Exit;                     @Stop the program
        

FIBONACCI:   
        POP {R2};                         
        POP {R1};                         
        PUSH {LR};                        @Push the Link register content 
        ADD R3, R1, R2;                   @F(n) - Fibonacci(n-1) + Fibonacci(n-2)
        PUSH {R2};       @Fibonacci(n-1) to stack
        PUSH {R3};                     
            
        SUBS R0, R0, #1;                  
        BNE CONT;                       
        B DONE;                           @Branch to DONE if complete

CONT:         
        BL FIBONACCI;                     @Recursively call the subroutine Fibonacci

DONE:                
        POP {R0};                         
        MOV R5, #4;                       
        MUL R4, R4, R5;                   
        ADD SP, SP, R4;
        POP {PC};                         @Pop the result to PC, return
        .end
            
          