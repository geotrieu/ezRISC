# Simple RISC Computer (ezRISC)

## George Trieu, Matt Garvin

### Datapath Architecture

The datapath architecture is based off of a 1-BUS design.
![Datapath Architecture Design](./documentation/datapath_architecture.png)
#### Components
- PC: Program Counter
	- 32-bit Register
	- Stores the memory address of the current instruction
- IR: Instruction Register
	- 32-bit Register
	- Stores the instruction fetched from memory
- General Purpose Register File
	- Collection of 16 32-bit Registers Numbered from R0 to R15
- MAR: Memory Address Register
	- Stores the address that will be queried from memory
- MD_MUX/MDR: Memory Data Multiplexer/Memory Data Register
	- MD_MUX
		- 32-bit 2-1 Multiplexer
		- If Reading from memory, pass memory data to MDR
		- If Writing to memory, pass bus data to MDR
	- MDR
		- 32-bit Register
		- Stores data to be written to (Read = 0) or read from (Read = 1) memory
- HI: High Register
	- 32-bit Register
	- Stores the upper 32 bits of the 64-bit Z Register
		- Remainder in Division Operations
- LO: Low Register
	- 32-bit Register
	- Stores the lower 32 bits of the 64-bit Z Register
		- Quotient in Division Operations
- Y_MUX/Y: Y Multiplexer/Y Register
	- Y_MUX
		- 32-bit 2-1 Multiplexer
		- If used to increment PC, select constant **0x4**
	- Y Register
		- 32-bit Register
		- Stores one of the operands used in ALU calculations
- ALU: Arithmetic Logic Unit
	- Performs arithmetic and logic operations
- Z: Z Register
	- 64-bit Register
	- Stores the result of the arithmetic operation
	- Can output upper or lower 32-bits onto the bus