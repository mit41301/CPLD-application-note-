onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /SPI_master_test/data_bus
add wave -noupdate -format Logic /SPI_master_test/mosi
add wave -noupdate -format Logic /SPI_master_test/sclk
add wave -noupdate -format Literal /SPI_master_test/ss
add wave -noupdate -format Logic /SPI_master_test/miso
add wave -noupdate -format Logic /SPI_master_test/CS
add wave -noupdate -format Literal /SPI_master_test/addr
add wave -noupdate -format Logic /SPI_master_test/pro_clk
add wave -noupdate -format Logic /SPI_master_test/WR
add wave -noupdate -format Logic /SPI_master_test/RD
add wave -noupdate -format Literal /SPI_master_test/data_send
add wave -noupdate -format Literal /SPI_master_test/transmit_store
add wave -noupdate -format Literal /SPI_master_test/data_receive
add wave -noupdate -format Literal /SPI_master_test/miso_data
add wave -noupdate -format Literal /SPI_master_test/mosi_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 193
configure wave -valuecolwidth 52
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
WaveRestoreZoom {0 ns} {94568 ns}
