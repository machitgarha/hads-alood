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
    constant seed_array: std_logic_vector(0 to 1) := ('0', '1');

    signal clock: std_logic;
    signal results: std_logic_vector(0 to 15);
begin
    clock_generator_instance: clock_generator generic map(200, 1 ns) port map(clock);

    l_seed_genenerator:
    for i in seed_array'range generate
        l_seed_genenerator:
        for j in seed_array'range generate
            l_seed_genenerator:
            for k in seed_array'range generate
                l_seed_genenerator:
                for l in seed_array'range generate
                    instance: random_bit_generator generic map(n) port map(
                        clock,
                        (seed_array(i), seed_array(j), seed_array(k), seed_array(l)), results(1 * i + 2 * j + 4 * k + 8 * l)
                    );
                end generate;
            end generate;
        end generate;
    end generate;
end architecture;
