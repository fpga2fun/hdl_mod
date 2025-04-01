onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /test/TESTS
add wave -noupdate -format Logic /test/clk
add wave -noupdate -format Logic /test/read
add wave -noupdate -format Logic /test/write
add wave -noupdate -format Literal -radix hexadecimal /test/data_in
add wave -noupdate -format Literal -radix hexadecimal /test/data_out
add wave -noupdate -format Literal -radix hexadecimal /test/address
add wave -noupdate -format Literal -radix unsigned /test/error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {327 ns} 0}
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
WaveRestoreZoom {1121 ns} {2047 ns}
