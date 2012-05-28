// === Initalize the stack pointer
@256
D = A
@0
M = D

// === push constant 111
// Load constant into D
@111
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 333
// Load constant into D
@333
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 888
// Load constant into D
@888
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop static 8
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@16
A = M
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
M = D

// === pop static 3
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@16
A = M
A = A + 1
A = A + 1
A = A + 1
M = D

// === pop static 1
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@16
A = M
A = A + 1
M = D

// === push static 3
@16 // Load the value of static 3 into D
A = M
D = A
@3
A = A + D
D = M
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push static 1
@16 // Load the value of static 1 into D
A = M
D = A
@1
A = A + D
D = M
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

// === push static 8
@16 // Load the value of static 8 into D
A = M
D = A
@8
A = A + D
D = M
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

