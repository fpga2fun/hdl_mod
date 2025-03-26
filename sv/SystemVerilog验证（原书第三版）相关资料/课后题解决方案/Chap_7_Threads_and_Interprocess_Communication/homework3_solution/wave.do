onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /top/risc_bus/clk
add wave -noupdate -radix hexadecimal /top/risc_bus/rst
add wave -noupdate /top/test/Driver::instr_str
add wave -noupdate -radix hexadecimal /top/risc_bus/data_out
add wave -noupdate -radix hexadecimal /top/risc_bus/address
add wave -noupdate -radix hexadecimal /top/risc_bus/data_in
add wave -noupdate -radix hexadecimal /top/risc_bus/write
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/R0_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/R1_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/R2_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/R3_out
add wave -noupdate -divider {RISC SPM}
add wave -noupdate -radix unsigned /my_package::Instruction::count
add wave -noupdate /my_package::Instruction::opcode_str
add wave -noupdate -radix hexadecimal /top/RISC_SPM/word_size
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Sel1_size
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Sel2_size
add wave -noupdate -radix hexadecimal /top/RISC_SPM/clk
add wave -noupdate -radix hexadecimal /top/RISC_SPM/rst
add wave -noupdate -radix hexadecimal /top/RISC_SPM/data_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/address
add wave -noupdate -radix hexadecimal /top/RISC_SPM/data_in
add wave -noupdate -radix hexadecimal /top/RISC_SPM/write
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Sel_Bus_1_Mux
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Sel_Bus_2_Mux
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Zflag
add wave -noupdate -radix hexadecimal /top/RISC_SPM/instruction
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Bus_1
add wave -noupdate -radix hexadecimal /top/RISC_SPM/mem_word
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_R0
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_R1
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_R2
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_R3
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_PC
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Inc_PC
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_IR
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_Add_R
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_Reg_Y
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Load_Reg_Z
add wave -noupdate -divider {Processing Unit}
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Sel1_size
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Sel2_size
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/word_size
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/op_size
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Bus_1
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/address
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/instruction
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Zflag
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/mem_word
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_R0
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_R1
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_R2
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_R3
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_IR
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_Add_R
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_Reg_Y
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_PC
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Inc_PC
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Load_Reg_Z
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Sel_Bus_1_Mux
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Sel_Bus_2_Mux
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/clk
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/rst
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/R0_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/R1_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/R2_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/R3_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Y_value
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/alu_out
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/Bus_2
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/PC_count
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/alu_zero_flag
add wave -noupdate -radix hexadecimal /top/RISC_SPM/Processor/opcode
add wave -noupdate -divider ALU
add wave -noupdate -divider {Control Unit}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1580 ns} 0}
configure wave -namecolwidth 161
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2185 ns} {4112 ns}
bookmark add wave bookmark0 {{0 ns} {4902 ns}} 22
