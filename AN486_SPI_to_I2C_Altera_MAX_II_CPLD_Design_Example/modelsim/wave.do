onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /SPI_to_I2C_test/I2C_sda
add wave -noupdate -format Logic /SPI_to_I2C_test/I2C_scl
add wave -noupdate -format Logic /SPI_to_I2C_test/SPI_miso
add wave -noupdate -format Logic /SPI_to_I2C_test/SPI_sclk
add wave -noupdate -format Logic /SPI_to_I2C_test/SPI_cs
add wave -noupdate -format Logic /SPI_to_I2C_test/SPI_mosi
add wave -noupdate -format Logic /SPI_to_I2C_test/I2C_sda_in
add wave -noupdate -format Logic /SPI_to_I2C_test/scl_in
add wave -noupdate -format Logic /SPI_to_I2C_test/I2C_scl_in
add wave -noupdate -format Literal /SPI_to_I2C_test/clk_count
add wave -noupdate -format Literal /SPI_to_I2C_test/command
add wave -noupdate -format Literal /SPI_to_I2C_test/data_send
add wave -noupdate -format Literal /SPI_to_I2C_test/data_store
add wave -noupdate -format Literal /SPI_to_I2C_test/data_recieve
add wave -noupdate -format Logic /SPI_to_I2C_test/check1
add wave -noupdate -format Logic /SPI_to_I2C_test/check2
add wave -noupdate -format Logic /SPI_to_I2C_test/check3
add wave -noupdate -format Logic /SPI_to_I2C_test/clk_en
add wave -noupdate -format Literal /SPI_to_I2C_test/r_seed
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 201
configure wave -valuecolwidth 49
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
WaveRestoreZoom {0 ps} {42052500 ns}
