library ieee;
use ieee.std_logic_1164.all;

entity main is
    generic(
        constant n: natural range 1 to natural'high;

        -- Pseudo Random Number Generator seed size
        constant prng_seed_size: natural range 3 to natural'high := 5
    );
    port(
        clock: in std_logic;

        enter_button, reset_button: in std_logic;
        input_number: in std_logic_vector(n - 1 downto 0);

        -- Pseudo Random Number Generator seed
        prng_seed: in std_logic_vector(0 to prng_seed_size - 1);

        led_correct, led_upper, led_less, led_lock: out std_logic;
        result_7_segment: out std_logic_vector(6 downto 0)
    );
end entity;

architecture structural of main is
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

    component register_n_bit is
        generic(
            constant n: integer
        );
        port(
            data: in std_logic_vector(n - 1 downto 0);
            clock: in std_logic;
            result: out std_logic_vector(n - 1 downto 0) := (others => '0');

            reset: in std_logic := '0';
            enable: in std_logic := '1'
        );
    end component;

    component comparator_n_bit is
        generic(
            constant n: integer
        );
        port(
            left_operand, right_operand: in std_logic_vector(n - 1 downto 0);
            lt, eq, gt: out std_logic
        );
    end component;

    component counter_n_bit is
        generic(
            constant n: natural
        );
        port(
            clock: in std_logic;
            result: out std_logic_vector(n - 1 downto 0) := (others => '0');

            enable: in std_logic := '1';
            clear: in std_logic := '0'
        );
    end component;

    component led_controller is
        port(
            lt, eq, gt, locked: in std_logic;
            led_correct, led_upper, led_less, led_lock: out std_logic
        );
    end component;

    component binary_3_bit_to_7_segment is
        port(
            data: in std_logic_vector(2 downto 0);
            result_7_segment: out std_logic_vector(6 downto 0)
        );
    end component;

    constant count_limit: std_logic_vector(2 downto 0) := o"7";

    signal enable_global, enable_prng: std_logic := '0';

    signal reached_count_limit: std_logic := '0';
    signal count: std_logic_vector(2 downto 0) := o"0";

    signal prng_done: std_logic;
    signal lt, eq, gt: std_logic;

    signal cur_input_number: std_logic_vector(n - 1 downto 0);
    signal random_number, cur_random_number: std_logic_vector(n - 1 downto 0);
begin
    reached_count_limit <= '1' when count = count_limit else '0';

    random_generator: random_generator_n_bit generic map(
        n => n,
        seed_size => prng_seed_size
    ) port map (
        clock => clock,
        seed => prng_seed,
        result => random_number,
        done => prng_done
    );

    random_number_register: register_n_bit generic map(n) port map(
        clock => clock,
        data => random_number,
        result => cur_random_number,
        enable => enable_prng,
        reset => reset_button
    );

    input_number_register: register_n_bit generic map(n) port map(
        clock => clock,
        data => input_number,
        result => cur_input_number,
        enable => enable_global,
        reset => reset_button
    );

    comparator: comparator_n_bit generic map(n) port map(
        left_operand => cur_input_number,
        right_operand => cur_random_number,
        lt => lt,
        eq => eq,
        gt => gt
    );

    led_controller_instace: led_controller port map(
        lt => lt,
        eq => eq,
        gt => gt,
        locked => reached_count_limit,
        led_correct => led_correct,
        led_upper => led_upper,
        led_less => led_less,
        led_lock => led_lock
    );

    count_counter: counter_n_bit generic map(3) port map(
        clock => clock,
        result => count,
        enable => enable_global,
        clear => reset_button
    );

    binary_3_bit_to_7_segment_instance: binary_3_bit_to_7_segment port map(
        data => count,
        result_7_segment => result_7_segment
    );

    process
    begin
        wait until rising_edge(enter_button) or rising_edge(reset_button);

        if rising_edge(reset_button) then
            enable_global <= '0';
            enable_prng <= '0';
        else -- if rising_edge(enter_button)
            if reached_count_limit = '0' then
                wait until falling_edge(clock);
                wait for 10 ps;

                enable_global <= '1';

                if count = o"0" then
                    enable_prng <= '1';
                end if;

                -- Make sure the values visit at least one rising edge.
                wait until falling_edge(clock);
                wait for 10 ps;
                enable_global <= '0';
                enable_prng <= '0';
            end if;
        end if;
    end process;
end architecture;
