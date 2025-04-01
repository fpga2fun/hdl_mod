onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /top/clk
add wave -noupdate -format Logic -radix hexadecimal /top/reset
add wave -noupdate -format Logic -radix hexadecimal /top/ahb_bus/HCLK
add wave -noupdate -format Literal -radix hexadecimal /top/ahb_bus/HADDR
add wave -noupdate -format Logic -radix hexadecimal /top/ahb_bus/HWRITE
add wave -noupdate -format Literal -radix hexadecimal /top/ahb_bus/HWDATA
add wave -noupdate -format Literal -radix hexadecimal /top/ahb_bus/HTRANS
add wave -noupdate -format Literal -radix hexadecimal /top/ahb_bus/HRDATA
add wave -noupdate -format Literal -radix hexadecimal /top/sram_bus/A
add wave -noupdate -format Logic -radix hexadecimal /top/sram_bus/CE_b
add wave -noupdate -format Logic -radix hexadecimal /top/sram_bus/WE_b
add wave -noupdate -format Logic -radix hexadecimal /top/sram_bus/OE_b
add wave -noupdate -format Literal -radix hexadecimal /top/sram_bus/DQ
add wave -noupdate -format Literal /top/async_sram/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1132 ns} 0}
configure wave -namecolwidth 267
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {1785 ns}
