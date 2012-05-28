// === Initalize the stack pointer
@256
D = A
@0
M = D

// === push constant 3030
// Load constant into D
@3030
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop pointer 0
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@3
M = D

// === push constant 3040
// Load constant into D
@3040
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop pointer 1
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@4
M = D

// === push constant 32
// Load constant into D
@32
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop this 2
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@3
A = M
A = A + 1
A = A + 1
M = D

// === push constant 46
// Load constant into D
@46
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop that 6
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@4
A = M
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
M = D

// === push pointer 0
@3 // Load the value of pointer 0 into D
D = M
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push pointer 1
@4 // Load the value of pointer 1 into D
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

// === push this 2
@3 // Load the value of this 2 into D
A = M
D = A
@2
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

// === push that 6
@4 // Load the value of that 6 into D
A = M
D = A
@6
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

