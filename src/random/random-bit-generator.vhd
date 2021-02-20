library ieee;
use ieee.std_logic_1164.all;

entity random_bit_generator is
    generic(
        -- The size of the input seed.
        constant n: natural range 3 to natural'high := 5
    );
    port(
        clock: in std_logic;
        seed: in std_logic_vector(0 to n - 1);
        result: out std_logic := '0'
    );
end entity;

architecture structural of random_bit_generator is
    type integer_array is array(natural range <>) of integer;

    signal seed_tmp: std_logic_vector(0 to n - 1) := seed;
begin
    process
        -- The distance of the two must be at least 2 (i.e. the selector having at least
        -- 3 elements).
        constant selector_range_start: natural := 0;
        constant selector_range_end_min: natural := 2;
        constant selector_range_end_max: natural := 100;
        variable selector_range_end: natural := selector_range_end_min;

        variable selector: integer_array(
            selector_range_start to selector_range_end_max
        );

        variable selector_to_init: boolean := true;
        constant selector_init_value: integer_array(
            selector_range_start to selector_range_end
        ) := (1, 1, 2);

        variable count: natural := 0;

        variable result_next_state: std_logic := '0';
    begin
        -- Initialize selector
        if selector_to_init then
            selector(selector_range_start to selector_range_end) := selector_init_value;
            selector_to_init := false;
        end if;

        -- Wait until clock reaches a stable state.
        wait until clock'event;
        wait for 10 ps;

        result_next_state := seed_tmp(selector(selector_range_end)) xor clock;

        result <= result_next_state;
        seed_tmp(selector(selector_range_start)) <= result_next_state;

        -- E.g. (a, b, c) -> (b, c, c)
        -- E.g. (a, b, c, d) -> (b, c, d, d)
        for i in selector_range_start to selector_range_end - 1 loop
            selector(i) := selector(i + 1);
        end loop;

        -- E.g. (b, c, c) -> (b, c, b + c)
        -- E.g. (b, c, d, d) -> (b, c, d, b + c + d)
        for i in selector_range_start to selector_range_end - 2 loop
            selector(selector_range_end) := selector(selector_range_end) +
                selector(i);
        end loop;

        -- Making sure the selector(s) do(es) not exceed seed bound
        selector(selector_range_end) := selector(selector_range_end) mod n;
    end process;
end architecture;
