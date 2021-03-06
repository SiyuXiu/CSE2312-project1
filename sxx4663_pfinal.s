/******************************************************************************
 * @Reference：file rand_array.s（author Christopher D. McMurrough）
 * @Student ID: 1001394663
 * @Student Name: Siyu Xiu ******************************************************************************/


.global main
.func main


main:
BL _start               @ give the input guide
MOV R0, #0              @ initialze index
MOV R8,#0               @ initialze index

writeloop:
CMP R0, #10             @ check to see if we are done iterating
BEQ writedone           @ exit loop if done
LDR R1, =a              @ get address of a
LSL R2, R0, #2          @ multiply index*4 to get array offset
ADD R2, R1, R2          @ R2 now has the element address
PUSH {R0}               @ backup iterator before procedure call
PUSH {R2}               @ backup element address before procedure call
BL _scanf               @ get input
POP {R2}                @ restore element address
STR R0, [R2]            @ write the address of a[i] to a[i]
POP {R0}                @ restore iterator
ADD R0, R0, #1          @ increment index
B   writeloop           @ branch to next loop iteration

writedone:
MOV R0, #0              @ initialze index variable

readloop:
CMP R0, #10             @ check to see if we are done iterating
BEQ readdone            @ exit loop if done
LDR R1, =a              @ get address of a
LSL R2, R0, #2          @ multiply index*4 to get array offset
ADD R2, R1, R2          @ R2 now has the element address
LDR R1, [R2]            @ read the array at address
PUSH {R0}               @ backup register before printf
PUSH {R1}               @ backup register before printf
PUSH {R2}               @ backup register before printf
MOV R2, R1              @ move array value to R2 for printf
MOV R1, R0              @ move array index to R1 for printf
BL  _printf             @ branch to print procedure with return
POP {R2}                @ restore register
POP {R1}                @ restore register
POP {R0}                @ restore register
ADD R0, R0, #1          @ increment index
B   readloop            @ branch to next loop iteration

readdone:
BL _prompt                 @ branch to printf to let user enter search value
BL _scanf                  @ get user's input
MOV R10,R0                @move user's input to R10 to compare with values in array
MOV R0,#0                  @ initialze index variable

compare:
CMP R0, #10             @ check to see if we are done iterating
BEQ comparedone         @ exit loop if done
LDR R1, =a              @ get address of a
LSL R2, R0, #2          @ multiply index*4 to get array offset
ADD R2, R1, R2          @ R2 now has the element address
LDR R1, [R2]            @ read the array at address
PUSH {R0}               @ backup register before printf
PUSH {R1}               @ backup register before printf
PUSH {R2}               @ backup register before printf
MOV R2, R1              @ move array value to R2 for printf
MOV R1, R0              @ move array index to R1 for printf
CMP R10,R2              @ compare input with array value
BLEQ _getresult         @ if they are equal, print the value
POP {R2}                @ restore register
POP {R1}                @ restore register
POP {R0}                @ restore register
ADD R0, R0, #1          @ increment index
B   compare            @ branch to next loop iteration

comparedone:
CMP R8,#0              @ figure out whether there is equal value
BLEQ _nonresult        @ if there is no equal value, go to _nonresult
BL _exit               @ exit

_getresult:
PUSH {LR}               @ store the return address
LDR R0, =printf_str     @ R0 contains formatted string address
BL printf               @ call printf
ADD R8,R8,#1            @ increment index
POP {PC}                @ restore the stack pointer and return


_prompt:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #21             @ print string length
LDR R1, =prompt_str     @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ return

_nonresult:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #40             @ print string length
LDR R1, =nonresult_str  @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ return
BL _exit                @ exit

_start:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #52             @ print string length
LDR R1, =start_str      @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ return

_scanf:
PUSH {LR}               @ store LR since scanf call overwrites
SUB SP, SP, #4          @ make room on stack
LDR R0, =format_str     @ R0 contains address of format string
MOV R1, SP              @ move SP to R1 to store entry on stack
BL scanf                @ call scanf
LDR R0, [SP]            @ load value at SP into R0
ADD SP, SP, #4          @ restore the stack pointer
POP {PC}                @ return

_printf:
PUSH {LR}               @ store the return address
LDR R0, =printf_str     @ R0 contains formatted string address
BL printf               @ call printf
POP {PC}                @ restore the stack pointer and return

_exit:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #21             @ print string length
LDR R1, =exit_str       @ string at label exit_str:
SWI 0                   @ execute syscall
MOV R7, #1              @ terminate syscall, 1
SWI 0                   @ execute syscall


.data
a:              .skip       40
format_str:     .asciz      "%d"
prompt_str:     .ascii      "ENTER A SEARCH VALUE:"
printf_str:     .asciz      "a[%d] = %d\n"

start_str:      .ascii      "Enter 10 positive integers, each followed by ENTER:\n"
nonresult_str:    .ascii     "That value does not exist in the array!\n"
exit_str:       .ascii      "Terminating program.\n"
