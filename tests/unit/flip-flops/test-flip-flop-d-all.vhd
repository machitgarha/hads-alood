library ieee;
use ieee.std_logic_1164.all;

entity test_flip_flop_d_all is
end entity;

architecture structural of test_flip_flop_d_all is
    component flip_flop_d_negative_edge is
        port(
            d, clock: in std_logic;
            q, q_not: out std_logic
        );
    end component;

    component flip_flop_d_positive_edge is
        port(
            d, clock: in std_logic;
            q, q_not: out std_logic
        );
    end component;

    component clock_generator is
        generic(
            constant cycle_iterations: integer := 0;
            constant half_cycle_period: time := 10 ns
        );
        port(
            clock: out std_logic
        );
    end component;

    signal data, clock, q_falling, q_rising, q_not_falling, q_not_rising: std_logic;
begin
    flip_flop_d_negative_edge_instance: flip_flop_d_negative_edge port map(
        data, clock, q_falling, q_not_falling
    );
    flip_flop_d_positive_edge_instance: flip_flop_d_positive_edge port map(
        data, clock, q_rising, q_not_rising
    );

    clock_generator_instance: clock_generator generic map(10, 5 ns) port map(clock);

    data <= '0',
        '1' after 9 ns,
        '0' after 18 ns,
        '1' after 26 ns,
        '0' after 34 ns,
        '1' after 51 ns,
        '0' after 53 ns,
        '1' after 62 ns,
        '0' after 72 ns,
        '1' after 73 ns,
        '0' after 74 ns,
        '1' after 79 ns,
        '0' after 89 ns,
        '1' after 96 ns;

end architecture;
