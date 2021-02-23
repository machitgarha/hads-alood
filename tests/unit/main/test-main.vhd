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
        923 ns, 940 ns, 1894 ns, 1907 ns, 2691 ns, 2718 ns, 2895 ns, 2922 ns, 3300 ns,
        3304 ns, 3876 ns, 3901 ns, 4714 ns, 4757 ns, 5245 ns, 5271 ns, 5665 ns, 5705 ns,
        5783 ns, 5792 ns, 6559 ns, 6567 ns, 7455 ns, 7475 ns, 7955 ns, 7956 ns, 8908 ns,
        8950 ns, 9738 ns, 9743 ns, 9933 ns, 9945 ns
    );
    constant reset_button_states: time_array := (10000 ns, 10001 ns);

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

    clock_generator_instance: clock_generator generic map(500, 10 ns) port map(clock);

    enter_button_generator_instance: switching_signal_generator
        generic map(enter_button_states) port map(enter_button);
    reset_button_generator_instance: switching_signal_generator
        generic map(reset_button_states) port map(reset_button);

    input_number <=
        x"1" after 230 ns,
        x"7" after 734 ns,
        x"c" after 1001 ns,
        x"a" after 1807 ns,
        x"d" after 1934 ns,
        x"c" after 2281 ns,
        x"d" after 2639 ns,
        x"0" after 3357 ns,
        x"e" after 4022 ns,
        x"9" after 4347 ns,
        x"1" after 4546 ns,
        x"7" after 5498 ns,
        x"7" after 5741 ns,
        x"5" after 6276 ns,
        x"2" after 7269 ns,
        x"9" after 7424 ns,
        x"b" after 7744 ns,
        x"4" after 8590 ns,
        x"8" after 9176 ns,
        x"e" after 9787 ns;
end architecture;
