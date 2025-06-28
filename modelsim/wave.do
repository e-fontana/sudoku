onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/clk
add wave -noupdate -label CRONOMETRO -radix unsigned /testbench/timer
add wave -noupdate /testbench/error
add wave -noupdate /testbench/pos_x
add wave -noupdate /testbench/pos_y
add wave -noupdate /testbench/score
add wave -noupdate /testbench/playtime
add wave -noupdate /testbench/board
add wave -noupdate /testbench/board_grid
add wave -noupdate /testbench/uut/sm/difficulty
add wave -noupdate /testbench/uut/sm/strikes
add wave -noupdate /testbench/uut/sm/index
add wave -noupdate /testbench/uut/sm/cell_value
add wave -noupdate /testbench/uut/sm/victory_condition
add wave -noupdate /testbench/uut/sm/defeat_condition
add wave -noupdate -expand -group {Estado Atual} -label {Estado Atual} -radix unsigned /testbench/uut/sm/current_state
add wave -noupdate -expand -group Buttons -label A /testbench/a_button
add wave -noupdate -expand -group Buttons -label B /testbench/b_button
add wave -noupdate -expand -group Buttons -label ⬆ /testbench/up_button
add wave -noupdate -expand -group Buttons -label ⬇ /testbench/down_button
add wave -noupdate -expand -group Buttons -label ⬅ /testbench/left_button
add wave -noupdate -expand -group Buttons -label ➡ /testbench/right_button
add wave -noupdate -expand -group Buttons -label ▶ /testbench/start_button
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
configure wave -valuecolwidth 128
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {386 ps}
