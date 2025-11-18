library verilog;
use verilog.vl_types.all;
entity SPI_Master is
    port(
        miso            : in     vl_logic;
        mosi            : out    vl_logic;
        sclk            : out    vl_logic;
        ss              : out    vl_logic_vector(7 downto 0);
        data_bus        : inout  vl_logic_vector(7 downto 0);
        CS              : in     vl_logic;
        addr            : in     vl_logic_vector(1 downto 0);
        pro_clk         : in     vl_logic;
        WR              : in     vl_logic;
        RD              : in     vl_logic
    );
end SPI_Master;
