library ieee;
use ieee.std_logic_1164.all;

entity test_random_generator_1_bit is
end entity;

architecture structural of test_random_generator_1_bit is
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

    constant n: natural := 1;
    constant seed_size: natural := 4;
    constant seed_array: std_logic_vector(0 to 1) := ('0', '1');

    type std_logic_vector_2d is array(natural range <>) of
        std_logic_vector(n - 1 downto 0);

    signal clock: std_logic;
    signal done_bits: std_logic_vector(0 to 15);
    signal results: std_logic_vector_2d(0 to 15);
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
                    instance: random_generator_n_bit generic map(n, seed_size) port map(
                        clock,
                        (seed_array(i), seed_array(j), seed_array(k), seed_array(l)), results(1 * i + 2 * j + 4 * k + 8 * l),
                        done_bits(1 * i + 2 * j + 4 * k + 8 * l)
                    );
                end generate;
            end generate;
        end generate;
    end generate;
end architecture;
