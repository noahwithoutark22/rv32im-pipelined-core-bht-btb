# rv32im-pipelined-core-bht-btb
A 5-stage pipelined **RV32IM RISC-V processor** implemented in Verilog. The processor supports the complete **RV32IM** instruction set and includes forwarding, hazard detection, and dynamic branch prediction using a **Branch History Table (BHT)** and **Branch Target Buffer (BTB)**.

## Features

* 5-stage pipeline (IF, ID, EX, MEM, WB)
* Complete **RV32IM** instruction support
* Data forwarding
* Load-use hazard detection and pipeline stalling
* Dynamic branch prediction using:

  * Branch Target Buffer (BTB)
  * 2-bit Branch History Table (BHT)
* Pipeline flush and recovery on branch misprediction
* Separate instruction and data memories

## Supported Instructions

### RV32I

* Arithmetic and logical instructions
* Load and store instructions
* Branch instructions
* JAL and JALR
* LUI and AUIPC

### RV32M

* MUL
* MULH
* MULHU
* MULHSU
* DIV
* DIVU
* REM
* REMU

## Verification

The processor was verified using multiple RV32IM assembly programs covering arithmetic operations, memory access, control flow, and the RV32M extension.

### Factorial

A factorial program was executed to compute **5!** using the `MUL` instruction.

| Input | Expected Output |
| :---: | :-------------: |
|   5   |       120       |

The computed result matched the expected output.

---

### Matrix Multiplication

A **3 × 3 matrix multiplication** program was used to verify the processor. The two input matrices were first loaded into the data memory. The processor then fetched the matrix elements, performed the required multiply-accumulate operations, and stored the resulting matrix back into the data memory.

#### Matrix A

|    |    |    |
| -: | -: | -: |
|  1 |  2 |  3 |
|  4 |  5 |  6 |
|  7 |  8 |  9 |

#### Matrix B

|    |    |    |
| -: | -: | -: |
|  9 |  8 |  7 |
|  6 |  5 |  4 |
|  3 |  2 |  1 |

#### Result Matrix

|     |     |    |
| --: | --: | -: |
|  30 |  24 | 18 |
|  84 |  69 | 54 |
| 138 | 114 | 90 |

The final contents of the data memory matched the expected matrix multiplication result.

---

### Bubble Sort

An unsorted array was first loaded into the data memory. The processor repeatedly loaded adjacent elements, compared them, performed swaps whenever required, and finally stored the sorted array back into the data memory.

#### Input Array

```text
[5, 2, 9, 1, 5, 6]
```

#### Sorted Output

```text
[1, 2, 5, 5, 6, 9]
```

The final contents of the data memory matched the expected sorted array, confirming the correct operation of load/store instructions, branching, comparisons, and memory updates.



## Tools Used

* Xilinx Vivado for simulation and verification

---
