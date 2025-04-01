onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test/TESTS
add wave -noupdate /test/clk
add wave -noupdate -radix hexadecimal /test/mem_bus/address
add wave -noupdate -radix hexadecimal /test/mem_bus/clk
add wave -noupdate -radix hexadecimal /test/mem_bus/data_in
add wave -noupdate -radix hexadecimal /test/mem_bus/data_out
add wave -noupdate -radix hexadecimal /test/mem_bus/read
add wave -noupdate -radix hexadecimal /test/mem_bus/write
add wave -noupdate /test/mem_bus/error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1303 ns} 0}
configure wave -namecolwidth 211
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {1785 ns}
