.data
a: .word 1, 2, 3, 4, 5
b: .word 6, 7, 8, 9, 10
print_text: .string "The dot product is: "

.text
main:
    la a0, a
    la a1, b
    li a2, 5
    jal dot_product_iterative       # dot_project_iterative(a0, a1, a2)
    j exit

dot_product_iterative:
    addi t5, x0, 0                  # initialize result to 0

    # Prepare Stack Pointer
    addi sp, sp, -16
    sw ra, 0(sp) # Save ra
    sw a0, 4(sp)  # Save a0
    sw a1, 8(sp)  # Save a1
    sw a2, 12(sp) # Save a2

# loop to compute dot product
dot_product_loop:
    # load current elements of a and b
    lw t1, 0(a0) # a[0]
    lw t2, 0(a1) # b[0]

    # compute product of current elements and accumulate
    mul t3, t1, t2
    add t5, t5, t3

    # move to next elements
    addi a0, a0, 4 # a = a + 1
    addi a1, a1, 4 # b = b + 1
    addi a2, a2, -1 # size = size - 1

    # check if loop should continue
    bnez a2, dot_product_loop

    # Restore Stack
    lw a2, 12(sp)
    lw a1, 8(sp)
    lw a0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 16

    # Exit loop if size becomes 0
    jr ra

exit:
    mv t0, a0

    # print the dot product
    addi a0, x0, 4
    la a1, print_text
    ecall

    mv a1, t5
    addi a0, x0, 1
    ecall

    # exit the program
    addi a0, x0, 10
    ecall
