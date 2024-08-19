.text
.extern printf
.global _start

_start:
	.global in_circle_func

in_circle_func:
	ldr x0, =P
	ldr x1, [x0]	// get x1
	ldr x2, [x0,#8]	// get y1
	ldr x0, =C
	ldr x3, [x0]	// get x2
	ldr x4, [x0,#8]	// get y1
	
	sub x1, x1, x3	// get x1-x2
	mul x1,	x1, x1	// put x1-x2 to power of 2
	sub x2, x2, x4	// get y1-y2
	mul x2,	x2, x2	// put y1-y2 to power of 2
	add x1, x1, x2	// add the values
	
	ldr x2, =R	// get pointer to radius
	ldr x2, [x2]	// get radius
	mul x2, x2, x2	// raise R to 2
	
	cmp x1, x2	// cmp R and distance
	b.le inside	// if distance eq R then point in circle
	
	ldr x0, =no	// since not in circle make x0 no for printf
	ldr x1, =no	// since not in circle make x1 no
	bl printf	// print
	b exit
inside:
	ldr x0, =yes	// since in circle make x0 yes for printf
	ldr x1, =yes	// since in circle make x1 yes
	bl printf	// print
	b exit
exit:
	mov x0,#0	/*status:=0*/
	mov w8,#93	/*exit is syscall #1 */
	svc #0		/*invoke syscall*/
	
.data
	P: .quad 0, 0
	C: .quad 1, 2
	R: .quad 2
	yes: .string "P is inside the circle.\n"
	no: .string "P is outside the circle.\n"

.end
