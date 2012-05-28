// === Initalize the stack pointer
@256
D = A
@0
M = D

// === push constant 17
// Load constant into D
@17
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 17
// Load constant into D
@17
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === eq
// Pop the top of the stack into D
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M - D
@EQ_SUCCESS_1
D;JEQ
D = 0
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1
@DONE_2
0;JMP
(EQ_SUCCESS_1)
D = -1
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1
(DONE_2)

// === push constant 892
// Load constant into D
@892
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 891
// Load constant into D
@891
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === lt
// Pop the top of the stack into D
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M - D
@LT_SUCCESS_3
D;JLT
D = 0
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1
@DONE_4
0;JMP
(LT_SUCCESS_3)
D = -1
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1
(DONE_4)

// === push constant 32767
// Load constant into D
@32767
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 32766
// Load constant into D
@32766
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === gt
// Pop the top of the stack into D
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M - D
@GT_SUCCESS_5
D;JGT
D = 0
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1
@DONE_6
0;JMP
(GT_SUCCESS_5)
D = -1
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1
(DONE_6)

// === push constant 56
// Load constant into D
@56
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 31
// Load constant into D
@31
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 53
// Load constant into D
@53
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === add
// Pop the top of the stack into D
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M + D
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 112
// Load constant into D
@112
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === sub
// Pop the top of the stack into D
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M - D
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === neg
// Pop the top of the stack into D
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
D = -D
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === and
// Pop the top of the stack into D
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M & D
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 82
// Load constant into D
@82
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === or
// Pop the top of the stack into D
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M | D
@0
A = M
M = D
@0 // Increment stack pointer
M = M + 1

