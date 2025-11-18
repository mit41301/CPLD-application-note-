library verilog;
use verilog.vl_types.all;
entity ufm_memory_altufm_i2c_91u is
    port(
        a1              : in     vl_logic;
        a2              : in     vl_logic;
        scl             : inout  vl_logic;
        sda             : inout  vl_logic
    );
end ufm_memory_altufm_i2c_91u;
