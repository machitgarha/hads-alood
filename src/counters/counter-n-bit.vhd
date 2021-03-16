library ieee;
use ieee.std_logic_1164.all;

entity counter_n_bit is
    generic(
        constant n: natural
    );
    port(
        clock: in std_logic;
        result: out std_logic_vector(n - 1 downto 0) := (others => '0');

        enable: in std_logic := '1';
        clear: in std_logic := '0'
    );
end entity;

architecture structural_flip_flop_t of counter_n_bit is
    component flip_flop_t_positive_edge is
        port(
            t, clock: in std_logic;
            clear: in std_logic := '0';
            q: buffer std_logic := '0';
            q_not: buffer std_logic := '1'
        );
    end component;

    signal flip_flop_t_inputs, flip_flop_t_outputs: std_logic_vector(n - 1 downto 0);
begin
    -- As all flip-flops include a clear port, there is no need to check clear here
    flip_flop_t_inputs(0) <= enable;

    l_flip_flop_t_generator:
    for i in 0 to n - 1 generate
        flip_flop_t_instance: flip_flop_t_positive_edge port map(
            t => flip_flop_t_inputs(i),
            clock => clock,
            clear => clear,
            q => flip_flop_t_outputs(i),
            q_not => open
        );

        l_check_i_bound:
        if i + 1 < n generate
            flip_flop_t_inputs(i + 1) <= flip_flop_t_inputs(i) and flip_flop_t_outputs(i);
        end generate;
    end generate;

    result <= flip_flop_t_outputs;
end architecture;
