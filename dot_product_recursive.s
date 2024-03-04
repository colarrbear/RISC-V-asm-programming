"""draft"""

.data
a: .word 1, 2, 3, 4, 5
b: .word 6, 7, 8, 9, 10
output: .string "Result: "
newline: .string "\n"

.text
main:
# Registers NOT to be used x0 to x4 and x10 to x17;
# Registers that we can use x5 to x9 and x18 to x31;

    addi x5, x0, 0      # let x5 be size and set it to 0
    # addi x6, x0, 0      # let x6 be sop and set it to 0
    addi x6, x0, 1      # let x6 be 1

    la x8, a        # loading the address of a to x8
    la x9, b        # loading the address of b to x9

loop1:

    beq x5, x6, exit1
    
    #bge x5, x7, exit1   # check if i >= 5, if so goto exit1

    slli x18, x5, 2     # set x18 to i*4
    add x19, x18, x8    # add i*4 to the base address of a and put it to x19
    lw x20, 0(x19)      # x20 = a[i]

    add x19, x18, x9    # x19 = i*4 + &b = &b[i]
    lw x21, 0(x19)      # x21 = b[i]

    mul x20, x20, x21   # a[i] = a[i] * b[i]

    add x6, x6, x20     # sop += x20

    addi x5, x5, 1      # to tell that loops end
    j loop1
    
exit1:
    
    li a0, 4                    # Print Output Label
    la a1, output
    ecall

    la a1, newline             # Print New linw
    ecall

    li a0, 1                    # Print sop
    mv a1, x6
    ecall

    li a0, 10
    ecall
    