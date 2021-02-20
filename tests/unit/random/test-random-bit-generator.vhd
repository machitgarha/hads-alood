library ieee;
use ieee.std_logic_1164.all;

entity test_random_bit_generator is
end entity;

architecture structural of test_random_bit_generator is
    component random_bit_generator is
        generic(
            constant n: natural range 3 to natural'high := 5
        );
        port(
            clock: in std_logic;
            seed: in std_logic_vector(0 to n - 1);
            result: out std_logic := '0'
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

    constant n: natural := 4;

    signal clock: std_logic;
    signal result: std_logic;

    signal seed: std_logic_vector(0 to n - 1) := "0101";
begin
    clock_generator_instance: clock_generator generic map(100, 1 ns) port map(clock);

    instance: random_bit_generator generic map(n) port map(clock, seed, result);
end architecture;
