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
        result_7_segment: out std_logic
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
begin
end architecture;
