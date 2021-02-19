library ieee;
use ieee.std_logic_1164.all;

entity random_bit_generator is
    generic(
        -- The algorithm to be chosen.
        constant algorithm_seed: natural;

        -- The size of the input seed.
        constant n: natural range 2 to natural'high := 4
    );
    port(
        seed: in std_logic_vector(n - 1 downto 0);
        clock: in std_logic;
        result: out std_logic := '0'
    );
end entity;

architecture structural of random_bit_generator is
    constant max_algorithm_number: natural := 3;
    constant algorithm_selector: natural := algorithm_seed mod max_algorithm_number;

    signal result_helpers: std_logic_vector(n - 1 downto -1) := (others => '0');
begin
    l_alorithm_1:
    if algorithm_selector = 0 generate
        result_helpers(-1) <= not clock;

        l_algorithm_1_generator:
        for i in 0 to n - 1 generate
            result_helpers(i) <= result_helpers(i - 1) xor seed(i);
        end generate;
    end generate;

    l_algorithm_2:
    if algorithm_selector = 1 generate
        result_helpers(-1) <= clock;

        l_algorithm_2_generator:
        for i in 0 to n - 1 generate
            l_algorithm_2_even_or_odd:
            if i mod 2 = 0 generate
                result_helpers(i) <= result_helpers(i - 1) nand seed(i);
            elsif i mod 2 = 1 generate
                result_helpers(i) <= result_helpers(i - 1) nor seed(i);
            end generate;
        end generate;
    end generate;

    l_algorithm_3:
    if algorithm_selector = 2 generate
        l_algorithm_3_first_half_generator:
        for i in 0 to n / 2 - 1 generate
            result_helpers(i) <= seed(i) xor seed(n - 1 - i);
        end generate;

        l_algorithm_3_second_half_generator:
        for i in n / 2 to n - 2 generate
            result_helpers(i) <= result_helpers(i - n / 2) xor result_helpers(i - 1);
        end generate;

        result_helpers(n - 1) <= result_helpers(n - 2) xor clock;
    end generate;

    result <= result_helpers(n - 1);
end architecture;
