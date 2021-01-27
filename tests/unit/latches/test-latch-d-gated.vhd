library ieee;
use ieee.std_logic_1164.all;

entity test_latch_d_gated is
end entity;

architecture structural of test_latch_d_gated is
    component latch_d_gated is
        port(
            d, clock: in std_logic;
            q, q_not: out std_logic
        );
    end component;

    component clock_generator is
        generic(
            constant cycle_iterations: integer := 40;
            constant half_cycle_period: time := 1 ns
        );
        port(
            clock: out std_logic
        );
    end component;

    signal data, clock, q, q_not: std_logic;
begin
    uut: latch_d_gated port map(data, clock, q, q_not);
    clock_generator_instance: clock_generator generic map(10, 3 ns) port map(clock);

    data <= '0',
        '1' after 4 ns,
        '0' after 11 ns,
        '1' after 16 ns,
        '0' after 26 ns,
        '1' after 28 ns,
        '0' after 31 ns,
        '1' after 34 ns,
        '0' after 35 ns,
        '1' after 40 ns,
        '0' after 50 ns,
        '1' after 53 ns,
        '0' after 59 ns;

end architecture;
