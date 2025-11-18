onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /nand_flash_testbench/t_cntrl
add wave -noupdate -format Literal /nand_flash_testbench/test_vector
add wave -noupdate -format Literal /nand_flash_testbench/test_out
add wave -noupdate -format Logic /nand_flash_testbench/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {79 ns} 0}
configure wave -namecolwidth 219
configure wave -valuecolwidth 58
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
update
WaveRestoreZoom {0 ns} {156 ns}
