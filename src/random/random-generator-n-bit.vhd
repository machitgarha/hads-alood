library ieee;
use ieee.std_logic_1164.all;

entity random_generator_n_bit is
    generic(
        -- Result size, i.e. number of random output bits.
        constant n: natural range 1 to natural'high;

        -- The size of the input seed.
        constant seed_size: natural range 3 to natural'high := 5
    );
    port(
        clock: in std_logic;
        seed: in std_logic_vector(0 to seed_size - 1);

        result: out std_logic_vector(n - 1 downto 0) := (others => '0');
        done: out std_logic := '0'
    );
end entity;

architecture structural of random_generator_n_bit is
    type integer_array is array(natural range <>) of integer;

    -- The period to wait until clock reaches a stable state.
    constant clock_stability_wait_period: time := 10 ps;

    -- The distance of the two  must be at least 2.
    -- I.e. the selector having at least 3 elements.
    constant selector_range_start: natural := 0;
    constant selector_range_end_min: natural := 2;
    constant selector_range_end_max: natural := 100;
    shared variable selector_range_end: natural := selector_range_end_min;

    shared variable selector, prev_selector: integer_array(
        selector_range_start to selector_range_end_max
    ) := (1, 1, 2, others => 0);

    signal seed_tmp: std_logic_vector(0 to seed_size - 1) := seed;
    signal result_tmp: std_logic_vector(n - 1 downto 0) := (others => '0');
begin
    process
    begin
        wait until clock'event;
        wait for clock_stability_wait_period;

        prev_selector := selector;
    end process;

    -- The distribution of random bit generation might not be diverse well, but the
    -- approximate results shows its diversity is acceptable.
    process
        -- Used to set 'done' port. It takes some time to fully generate n random bits,
        -- so this variable takes care of this.
        variable clock_cylces: natural := 0;

        -- Count is a dynamic index to change the algorithm in the case of repetition.
        variable count: natural := 0;
        variable count_limit: natural := 0;

        variable result_lsb_tmp: std_logic := '0';
    begin
        wait until clock'event;
        wait for clock_stability_wait_period * 2;

        -- Managing 'done' bit
        clock_cylces := clock_cylces + 1;
        if clock_cylces >= n then
            done <= '1';
        else
        end if;

        -- Shift result to left by one
        for i in n - 1 downto 1 loop
            result_tmp(i) <= result_tmp(i - 1);
        end loop;

        result_lsb_tmp := seed_tmp(prev_selector(selector_range_end)) xor clock;

        result_tmp(0) <= result_lsb_tmp;
        seed_tmp(prev_selector(selector_range_start)) <= result_lsb_tmp;

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

        -- This must be seed and not seed_tmp. Changing it to seed_tmp leads to more
        -- predictable results.
        if seed(count mod seed_size) = '1' then
            selector(selector_range_end) := selector(selector_range_end) + 1;
        end if;

        -- Making sure the selector(s) do(es) not exceed seed bound
        selector(selector_range_end) := selector(selector_range_end) mod seed_size;

        count := count + 1;

        -- Generate a random count_limit
        count_limit := 0;
        for i in selector_range_start to selector_range_end loop
            count_limit := count_limit + selector(i);
        end loop;
        count_limit := count_limit * 2;

        -- When count reaches an approximate value, based on seed size and selector size,
        -- we guess the algorithm to be trapped in a predictable iteration. So, we extend
        -- the selector size, and thus change its manipulation method (see loops above),
        -- to prevent this.
        if count >= count_limit then
            selector_range_end := selector_range_end + 1;

            if selector_range_end > selector_range_end_max then
                selector_range_end := selector_range_end_min;
            end if;

            for i in selector_range_start to selector_range_end - 1 loop
                selector(selector_range_end) := selector(selector_range_end) +
                    selector(i);
            end loop;
            selector(selector_range_end) := selector(selector_range_end) mod seed_size;

            count := selector_range_end;
        end if;
    end process;

    result <= result_tmp;
end architecture;
