// === Initalize the stack pointer
@256
D = A
@0
M = D

// === push constant 10
// Load constant into D
@10
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop local 0
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@1
A = M
M = D

// === push constant 21
// Load constant into D
@21
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 22
// Load constant into D
@22
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop argument 2
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@2
A = M
A = A + 1
A = A + 1
M = D

// === pop argument 1
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@2
A = M
A = A + 1
M = D

// === push constant 36
// Load constant into D
@36
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop this 6
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@3
A = M
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
A = A + 1
M = D

// === push constant 42
// Load constant into D
@42
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push constant 45
// Load constant into D
@45
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop that 5
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
M = D

// === pop that 2
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@4
A = M
A = A + 1
A = A + 1
M = D

// === push constant 510
// Load constant into D
@510
D = A
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === pop temp 6
@0 // Decremement stack pointer
M = M - 1
@0
A = M
D = M
@11
M = D

// === push local 0
@1 // Load the value of local 0 into D
A = M
D = A
@0
A = A + D
D = M
@0 // Place the value in D at the top of the stack
A = M
M = D
@0 // Increment stack pointer
M = M + 1

// === push that 5
@4 // Load the value of that 5 into D
A = M
D = A
@5
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

// === push argument 1
@2 // Load the value of argument 1 into D
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

// === push this 6
@3 // Load the value of this 6 into D
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

// === push this 6
@3 // Load the value of this 6 into D
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

// === push temp 6
@11 // Load the value of temp 6 into D
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

