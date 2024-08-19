.text
.extern printf

.equ ELEM, 9 // number of elements

.global _start
_start:
    .global max_func
    
max_func:
    ldr x0, =stack // load the stack pointer
    mov sp, x0
    sub sp, sp, #16
    str x30, [sp]
    
    mov x2, #ELEM // number of elements
    ldr x1, =vec // address of the first element
    bl fmax // call the maximum finding function
    
    // RETURNS FROM LOOP
    ldr x8, =out // address of the result
    str x1, [x8] // save the result

    // PRINTING VALUE
    ldr x0, =maximum  // load value string maximum into x0
    bl printf         // print

    // LEAVING
    ldr x0, =exit // load the exit label into x0
    br x0 // branch to the exit label

.exit:
    mov x8, #93        // Exit system call number
    mov x0, #0         // Exit status code
    svc #0             // Make system call

// FUNCTION FMAXX
.func fmax
fmax:
    stp x1, x2, [sp, #-16]! // save x1 and x2 on the stack
    stp x3, x30, [sp, #-16]! // save x3 and x30 (lr) on the stack

    ldr x0, [x1] // Initialize the maximum with the first element
    sub x2, x2, #1 // x2-- 

.fmax_loop:
    cmp x2, #0     // check if the loop counter is zero
    b.eq .fmax_end  // terminate the function if the loop counter is zero

    add x1, x1, #8 // move to the next element (1 byte apart)
    ldr x3, [x1]   // load current element

    cmp x3, x0      // compare the current element with the current maximum
    b.le .fmax_loop_continue // If <= continue with the next element
    mov x0, x3 // else update the maximum
    b .fmax_loop_continue

.fmax_loop_continue:
    sub x2, x2, #1 // x2--
    b .fmax_loop // Repeat for the next element

.fmax_end:
    ldp x3, x30, [sp], #16 // reload the registers x3 and x30 (lr)
    ldp x1, x2, [sp], #16 // reload the registers x1 and x2

    mov x1, x0   // move maximum to x1
    br x30 // jump to caller, ret

.data
vec:
    .quad 1,2,3,4,5,6,7,8,9// elements
maximum:
    .string "Maximum Value: %d\n"

.bss
    .align 8
out:
    .space 8 // space for the result

    .align 16
    .space 4096 // space for the stack

stack:
    .space 16 // stack base address

.end
