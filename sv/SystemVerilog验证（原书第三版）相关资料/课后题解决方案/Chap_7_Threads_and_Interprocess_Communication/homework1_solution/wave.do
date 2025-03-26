onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /top/clk
add wave -noupdate -radix hexadecimal /top/reset
add wave -noupdate -radix hexadecimal /top/arb_bus0/req
add wave -noupdate -radix hexadecimal /top/arb_bus1/req
add wave -noupdate -radix hexadecimal /top/arb_bus2/req
add wave -noupdate -radix hexadecimal /top/arb_bus0/en
add wave -noupdate -radix hexadecimal /top/arb_bus1/en
add wave -noupdate -radix hexadecimal /top/arb_bus2/en
add wave -noupdate -radix hexadecimal /top/arb_bus0/grant
add wave -noupdate -radix hexadecimal /top/arb_bus1/grant
add wave -noupdate -radix hexadecimal /top/arb_bus2/grant
add wave -noupdate /top/error
add wave -noupdate -radix binary /top/golden/port_priority
add wave -noupdate -divider arb_bus0
add wave -noupdate -radix hexadecimal /top/arb_bus0/clk
add wave -noupdate -divider arb_bus1
add wave -noupdate -radix hexadecimal /top/arb_bus1/clk
add wave -noupdate -divider arb_bus2
add wave -noupdate -radix hexadecimal /top/arb_bus2/clk
add wave -noupdate -divider arbiter
add wave -noupdate -radix hexadecimal /top/arbiter/clk
add wave -noupdate -radix hexadecimal /top/arbiter/reset
add wave -noupdate -radix hexadecimal /top/arbiter/req0
add wave -noupdate -radix hexadecimal /top/arbiter/req1
add wave -noupdate -radix hexadecimal /top/arbiter/req2
add wave -noupdate -radix hexadecimal /top/arbiter/en0
add wave -noupdate -radix hexadecimal /top/arbiter/en1
add wave -noupdate -radix hexadecimal /top/arbiter/en2
add wave -noupdate -radix hexadecimal /top/arbiter/grant0
add wave -noupdate -radix hexadecimal /top/arbiter/grant1
add wave -noupdate -radix hexadecimal /top/arbiter/grant2
add wave -noupdate -radix ascii /top/arbiter/ASCII_priority
add wave -noupdate -divider golden
add wave -noupdate -radix hexadecimal /top/golden/clk
add wave -noupdate -radix hexadecimal /top/golden/reset
add wave -noupdate -radix hexadecimal -expand -subitemconfig {{/top/golden/req[2]} {-height 23 -radix hexadecimal} {/top/golden/req[1]} {-height 23 -radix hexadecimal} {/top/golden/req[0]} {-height 23 -radix hexadecimal}} /top/golden/req
add wave -noupdate -radix hexadecimal -expand -subitemconfig {{/top/golden/en[2]} {-height 23 -radix hexadecimal} {/top/golden/en[1]} {-height 23 -radix hexadecimal} {/top/golden/en[0]} {-height 23 -radix hexadecimal}} /top/golden/en
add wave -noupdate -radix hexadecimal -expand -subitemconfig {{/top/golden/grant[2]} {-height 23 -radix hexadecimal} {/top/golden/grant[1]} {-height 23 -radix hexadecimal} {/top/golden/grant[0]} {-height 23 -radix hexadecimal}} /top/golden/grant
add wave -noupdate -radix hexadecimal -expand -subitemconfig {{/top/golden/port_priority[2]} {-height 23 -radix hexadecimal} {/top/golden/port_priority[1]} {-height 23 -radix hexadecimal} {/top/golden/port_priority[0]} {-height 23 -radix hexadecimal}} /top/golden/port_priority
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {440 ns} 0}
configure wave -namecolwidth 245
configure wave -valuecolwidth 90
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
WaveRestoreZoom {1064 ns} {2340 ns}
bookmark add wave bookmark0 {{0 ns} {1431 ns}} 8
