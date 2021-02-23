library ieee;
use ieee.std_logic_1164.all;
use work.types.time_array;

entity test_main is
end entity;

architecture structural of test_main is
    component main is
        generic(
            constant n: natural range 1 to natural'high;
            constant prng_seed_size: natural range 3 to natural'high := 5
        );
        port(
            clock: in std_logic;

            enter_button, reset_button: in std_logic;
            input_number: in std_logic_vector(n - 1 downto 0);

            prng_seed: in std_logic_vector(0 to prng_seed_size - 1);

            led_correct, led_upper, led_less, led_lock: out std_logic;
            result_7_segment: out std_logic_vector(6 downto 0)
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

    component switching_signal_generator is
        generic(
            constant switch_timing: time_array
        );
        port(
            result: buffer std_logic;
            initial_value: in std_logic := '0'
        );
    end component;

    constant n: natural := 4;
    constant seed_size: natural := 7;
    constant seed: std_logic_vector(0 to seed_size - 1) := "0011101";

    constant enter_button_states: time_array := (
        253 ns, 255 ns, 285 ns, 313 ns, 347 ns, 433 ns, 463 ns, 491 ns,
        546 ns, 609 ns, 676 ns, 745 ns, 804 ns, 871 ns, 923 ns, 1014 ns, 1015 ns, 1065 ns,
        1147 ns, 1171 ns, 1210 ns, 1243 ns, 1289 ns, 1383 ns, 1384 ns, 1438 ns, 1488 ns,
        1552 ns, 1568 ns, 1617 ns, 1709 ns, 1791 ns, 1800 ns, 1873 ns, 1917 ns, 2000 ns
    );
    constant reset_button_states: time_array := (
        404 ns, 407 ns, 613 ns, 615 ns, 915 ns, 921 ns, 1347 ns, 1349 ns, 1464 ns,
        1467 ns, 1864 ns, 1870 ns
    );

    signal clock, enter_button, reset_button,
        led_correct, led_upper, led_less, led_lock: std_logic := '0';
    signal input_number: std_logic_vector(n - 1 downto 0);
    signal result_7_segment: std_logic_vector(6 downto 0);
begin
    instance: main generic map(n, seed_size) port map(
        clock,
        enter_button,
        reset_button,
        input_number,
        seed,
        led_correct,
        led_upper,
        led_less,
        led_lock,
        result_7_segment
    );

    clock_generator_instance: clock_generator generic map(100, 10 ns) port map(clock);

    enter_button_generator_instance: switching_signal_generator
        generic map(enter_button_states) port map(enter_button);
    reset_button_generator_instance: switching_signal_generator
        generic map(reset_button_states) port map(reset_button);

    input_number <=
        x"2" after 171 ns,
        x"b" after 264 ns,
        x"c" after 455 ns,
        x"0" after 518 ns,
        x"6" after 543 ns,
        x"5" after 633 ns,
        x"d" after 820 ns,
        x"f" after 976 ns,
        x"3" after 1161 ns,
        x"8" after 1309 ns,
        x"8" after 1324 ns,
        x"2" after 1378 ns,
        x"9" after 1520 ns,
        x"e" after 1694 ns,
        x"a" after 1881 ns,
        x"5" after 1966 ns,
        x"5" after 1989 ns;
end architecture;
