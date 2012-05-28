// === Initalize the stack pointer
@256
D = A
@0
M = D

// === push constant 7
// Load constant into D
@7
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 8
// Load constant into D
@8
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

