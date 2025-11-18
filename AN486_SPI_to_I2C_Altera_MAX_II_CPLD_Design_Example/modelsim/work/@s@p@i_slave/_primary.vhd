library verilog;
use verilog.vl_types.all;
entity SPI_slave is
    port(
        miso            : out    vl_logic;
        mosi            : in     vl_logic;
        cs              : in     vl_logic;
        sclk            : in     vl_logic;
        command_reg     : out    vl_logic_vector(7 downto 0);
        data_in         : out    vl_logic_vector(7 downto 0);
        status_reg      : in     vl_logic_vector(7 downto 0);
        data_out        : in     vl_logic_vector(7 downto 0);
        count_bit       : out    vl_logic_vector(2 downto 0);
        count_byte      : out    vl_logic;
        count           : out    vl_logic_vector(3 downto 0);
        done            : out    vl_logic;
        done1           : out    vl_logic;
        count_byte1     : out    vl_logic;
        count_1         : out    vl_logic_vector(3 downto 0)
    );
end SPI_slave;
