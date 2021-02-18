library ieee;
use ieee.std_logic_1164.all;
use work.types.time_array;

entity test_counter_3_bit is
end entity;

architecture structural of test_counter_3_bit is
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

    constant n: natural := 3;

    constant clear_switch_timing: time_array := (
        13 ns, 14 ns, 19 ns, 20 ns, 52 ns, 53 ns
    );
    constant enable_switch_timing: time_array := (
        4 ns, 17 ns, 19 ns, 37 ns, 49 ns, 53 ns, 56 ns, 59 ns, 61 ns, 74 ns, 80 ns
    );

    signal clock, clear, enable: std_logic;
    signal count: std_logic_vector(n - 1 downto 0);
begin
    instance: counter_n_bit generic map(n) port map(
        clock => clock,
        clear => clear,
        enable => enable,
        result => count
    );

    clock_generator_instance: clock_generator generic map(20, 3 ns) port map(clock);

    clear_generator_instance: switching_signal_generator generic map(clear_switch_timing)
        port map(clear);
    enable_generator_instance: switching_signal_generator
        generic map(enable_switch_timing)
        port map(enable);
end architecture;
