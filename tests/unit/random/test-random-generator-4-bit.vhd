library ieee;
use ieee.std_logic_1164.all;

entity test_random_generator_4_bit is
end entity;

architecture structural of test_random_generator_4_bit is
    component random_generator_n_bit is
        generic(
            constant n: natural range 1 to natural'high;
            constant seed_size: natural range 3 to natural'high := 5
        );
        port(
            clock: in std_logic;
            seed: in std_logic_vector(0 to seed_size - 1);
            result: out std_logic_vector(n - 1 downto 0) := (others => '0');
            done: out std_logic := '0'
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
    constant seed_size: natural := 6;

    signal clock, done: std_logic;
    signal result: std_logic_vector(n - 1 downto 0);
begin
    clock_generator_instance: clock_generator generic map(50, 1 ns) port map(clock);

    instance: random_generator_n_bit generic map(n, seed_size) port map(
        clock, "001001", result, done
    );
end architecture;
