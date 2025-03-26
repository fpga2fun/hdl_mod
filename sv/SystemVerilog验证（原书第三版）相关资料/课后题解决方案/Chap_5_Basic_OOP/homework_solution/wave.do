onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /top/mem_bus/read_write_not_assert
add wave -noupdate -format Literal /top/mem_bus/write_read_not_assert
add wave -noupdate -format Logic -radix hexadecimal /top/my_mem/mem_bus/clk
add wave -noupdate -format Logic -radix hexadecimal /top/my_mem/mem_bus/write
add wave -noupdate -format Logic -radix hexadecimal /top/my_mem/mem_bus/read
add wave -noupdate -format Literal -radix hexadecimal /top/my_mem/mem_bus/data_in
add wave -noupdate -format Literal -radix hexadecimal /top/my_mem/mem_bus/address
add wave -noupdate -format Literal -radix hexadecimal /top/my_mem/mem_bus/data_out
add wave -noupdate -format Literal -radix hexadecimal /top/my_mem/mem_bus/cb/data_out
add wave -noupdate -format Literal -radix hexadecimal /top/my_mem/mem_bus/cb/address
add wave -noupdate -format Literal -radix hexadecimal /top/my_mem/mem_bus/cb/data_in
add wave -noupdate -format Logic -radix hexadecimal /top/my_mem/mem_bus/cb/read
add wave -noupdate -format Logic -radix hexadecimal /top/my_mem/mem_bus/cb/write
add wave -noupdate -format Event -radix hexadecimal /top/my_mem/mem_bus/cb/cb_event
add wave -noupdate -format Literal /my_package::Transaction::error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {468 ns} 0}
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
WaveRestoreZoom {0 ns} {1628 ns}
