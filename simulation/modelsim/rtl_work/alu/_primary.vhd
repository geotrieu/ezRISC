library verilog;
use verilog.vl_types.all;
entity alu is
    generic(
        REG_SIZE        : integer := 32
    );
    port(
        ctrl_sig        : in     vl_logic_vector(3 downto 0);
        y_data_in       : in     vl_logic_vector;
        bus_data_in     : in     vl_logic_vector;
        z_data_out      : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of REG_SIZE : constant is 1;
end alu;
