library verilog;
use verilog.vl_types.all;
entity ufm_memory is
    port(
        a1              : in     vl_logic;
        a2              : in     vl_logic;
        scl             : inout  vl_logic;
        sda             : inout  vl_logic
    );
end ufm_memory;
