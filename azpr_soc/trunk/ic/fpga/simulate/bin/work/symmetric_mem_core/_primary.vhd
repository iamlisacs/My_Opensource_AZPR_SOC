library verilog;
use verilog.vl_types.all;
entity symmetric_mem_core is
    generic(
        RAM_WIDTH       : integer := 32;
        RAM_ADDR_BITS   : integer := 12
    );
    port(
        clockA          : in     vl_logic;
        clockB          : in     vl_logic;
        write_enableA   : in     vl_logic;
        write_enableB   : in     vl_logic;
        addressA        : in     vl_logic_vector;
        addressB        : in     vl_logic_vector;
        input_dataA     : in     vl_logic_vector;
        input_dataB     : in     vl_logic_vector;
        output_dataA    : out    vl_logic_vector;
        output_dataB    : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RAM_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of RAM_ADDR_BITS : constant is 1;
end symmetric_mem_core;
