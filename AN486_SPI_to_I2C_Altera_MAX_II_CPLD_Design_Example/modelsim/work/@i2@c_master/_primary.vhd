library verilog;
use verilog.vl_types.all;
entity I2C_master is
    port(
        sda             : inout  vl_logic;
        scl             : inout  vl_logic;
        cpld_clk        : in     vl_logic;
        command_reg     : in     vl_logic_vector(7 downto 0);
        command_word    : out    vl_logic_vector(7 downto 0);
        status_reg      : out    vl_logic_vector(7 downto 0);
        count_byte      : in     vl_logic;
        cs              : in     vl_logic;
        data_in         : in     vl_logic_vector(7 downto 0);
        data_out        : out    vl_logic_vector(7 downto 0);
        sda_out         : out    vl_logic;
        sda_out1        : out    vl_logic;
        scl_out         : out    vl_logic;
        count           : out    vl_logic_vector(3 downto 0);
        sda_is_ack      : out    vl_logic;
        repeat_start    : out    vl_logic;
        sda_out_en      : out    vl_logic;
        start_stop      : out    vl_logic;
        start           : out    vl_logic;
        stop            : out    vl_logic
    );
end I2C_master;
