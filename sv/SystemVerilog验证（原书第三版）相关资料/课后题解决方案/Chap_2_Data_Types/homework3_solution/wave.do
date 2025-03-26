onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /test/address
add wave -noupdate -format Logic -radix hexadecimal /test/clk
add wave -noupdate -format Literal -radix hexadecimal /test/data_in
add wave -noupdate -format Literal -radix hexadecimal /test/data_out
add wave -noupdate -format Literal -radix hexadecimal /test/error
add wave -noupdate -format Literal -radix hexadecimal /test/my_reg
add wave -noupdate -format Logic -radix hexadecimal /test/reset
add wave -noupdate -format Logic -radix hexadecimal /test/write
add wave -noupdate -divider config_reg
add wave -noupdate -format Logic -radix hexadecimal /test/config_reg/clk
add wave -noupdate -format Logic -radix hexadecimal /test/config_reg/reset
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/data_in
add wave -noupdate -format Logic -radix hexadecimal /test/config_reg/write
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/address
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/data_out
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/adc0_reg
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/adc1_reg
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/amp_gain
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/analog_test
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/digital_config
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/digital_test
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/temp_sensor0_reg
add wave -noupdate -format Literal -radix hexadecimal /test/config_reg/temp_sensor1_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4700 ns} 0}
configure wave -namecolwidth 242
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
WaveRestoreZoom {2100 ns} {3416 ns}
