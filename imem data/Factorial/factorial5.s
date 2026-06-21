# factorial(5) using RV32IM
        addi t0, x0, 5      # n = 5
        addi t1, x0, 1      # result = 1
loop:
        beq  t0, x0, end
        mul  t1, t1, t0
        addi t0, t0, -1
        jal  x0, loop
end:
        addi a0, t1, 0
        ebreak
