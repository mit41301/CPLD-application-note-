library verilog;
use verilog.vl_types.all;
entity SPI_to_I2C is
    port(
        SPI_sclk        : in     vl_logic;
        SPI_cs          : in     vl_logic;
        SPI_miso        : out    vl_logic;
        SPI_mosi        : in     vl_logic;
        I2C_sda         : inout  vl_logic;
        I2C_scl         : inout  vl_logic
    );
end SPI_to_I2C;
