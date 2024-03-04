.text

mult:
    # Save registers on the stack
    addi sp, sp, -8  # Move stack pointer down 8 bytes

    # Store a and ra on the stack
    sw a0, 4(sp)   # Store a
    sw ra, 0(sp)   # Store ra

    # Set temporary register t0 to b + 1
    addi t0, x0, 1  # t0 = b + 1

    # Check if b != 1, if not, jump to return
    bne a1, t0, return  # Branch if a1 (b) != t0 (b + 1)

    # Base Case (b == 1)
    # Restore registers and return
    addi sp, sp, 8  # Move stack pointer up 8 bytes
    jr ra          # Return a

main:
    # Set arguments for mult function
    addi a0, x0, 110 # a = 110
    addi a1, x0, 50  # b = 50

    # Call mult function and store return value in a0
    jal mult

    # Move function return value (a) to a1
    mv a1, a0

    # Set argument for ecall
    addi a0, x0, 1  # Print value (a)

    # Print the value (a)
    ecall

    # Jump to exit
    j exit

return:
    # Decrement b by 1
    addi a1, a1, -1 # b = b - 1

    # Recursive call to mult
    jal mult        # Call mult(a, b-1)

    # Restore registers and load return value
    lw t1, 4(sp)   # Load a from stack
    lw ra, 0(sp)   # Load ra from stack
    addi sp, sp, 8  # Move stack pointer up 8 bytes

    # Add return value of the recursive call to a (a + mult(a, b-1))
    add a0, a0, t1

    # Return from the function
    jr ra

exit:
    # Set argument for ecall
    addi a0, x0, 10 # Exit code (10)

    # Exit the program
    ecall