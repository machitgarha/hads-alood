library ieee;
use ieee.std_logic_1164.all;

entity clock_generator is
    generic(
        -- How many cycles to generate
        constant cycle_iterations: integer := 40;

        -- The period of half a cycle
        constant half_cycle_period: time := 1 ns
    );
    port(
        clock: out std_logic
    );
end entity;

architecture structural of clock_generator is
    signal clock_tmp: std_logic := '0';
begin
    l_clock_generator:
    for i in 0 to cycle_iterations - 1 generate
        clock_tmp <= not clock_tmp after half_cycle_period;
    end generate;

    -- Everything is concurrent, so it can be outside of the generate loop above
    clock <= clock_tmp;
end architecture;
