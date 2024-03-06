.data
    a: .word 1, 2, 3, 4, 5
    b: .word 6, 7, 8, 9, 10
    text: .string "The dot product is: "
    newline: .string "\n"
.text
main:
    la a0, a        # loading the address of a 
    la a1, b        # loading the address of a
    li a2, 5        # loading size of both arrays

    jal dp_recursive    # calling the recursive function
    mv t5, a0           # move the result to t5
    # j exit
    
    addi a0, x0, 4 # load 4 to a0
    la a1, text # load address of dotproduct to a1
    ecall # Environment call

    # print_int; result
    addi a0, x0, 1 # load 1 to a0
    mv a1, t5 # move the result to a1
    ecall # Environment call
    
    # use print_string to print a newline
    addi a0, x0, 4 # load 4 to a0
    la a1, newline # load address of newline to a1
    ecall # Environment call
    
    # terminate the program
    addi a0, x0, 10 # load 10 to a0
    ecall # Environment call

dp_recursive:
        # base case
    addi x7, x0, 1              # let x7 be 1
    beq a2, x7, exit_basecase   # if size is 1, then exit

    addi sp, sp, -16            # decrement stack pointer
    sw ra, 0(sp)  # save &ra in stack
    sw a0, 4(sp)  # save &a0 in stack
    sw a1, 8(sp)  # save &a1 in stack
    sw a2, 12(sp) # save a2 in stack

    # move array index  a[i] -> a[i+1]
    addi a0, a0, 4
    addi a1, a1, 4
    
    # reduced size by one
    addi a2, a2, -1
    # call recursive a[0]*b[0] + dp_recursive
    jal dp_recursive

    # restore 
    lw t3, 12(sp)  # load lenght              
    lw t2, 8(sp)  # load &array2                
    lw t1, 4(sp)  # load &array1               
    lw ra, 0(sp) # load &ra
    addi sp, sp, 16  # return stack pointer reserve

    # convert address array to value
    lw t1, 0(t1)  # *t1 = &t1  or  t1 = a[0]
    lw t2, 0(t2)  # *t2 = &t2  or  t2 = b[0]

    mul t3, t1, t2  # x0 = a[0] * b[0]

    add a0, a0, t3  # result =+  a[0] * b[0]

    jr ra   # return


exit_basecase:
    lw x3, 0(a0)                # load a[0] into x3
    lw x4, 0(a1)                # load b[0] into x4
    mul a0, x3, x4              # a0 = a[0] * b[0]
    jr ra