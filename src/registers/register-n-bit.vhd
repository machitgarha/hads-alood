library ieee;
use ieee.std_logic_1164.all;

entity register_n_bit is
    generic(
        constant n: integer
    );
    port(
        data: in std_logic_vector(n - 1 downto 0);
        clock: in std_logic;
        result: out std_logic_vector(n - 1 downto 0);

        -- Enable turns the register on or off.
        enable: in std_logic := '1'
    );
end entity;

architecture structural of register_n_bit is
    component flip_flop_d_positive_edge is
        port(
            d, clock: in std_logic;
            q, q_not: out std_logic
        );
    end component;

    -- Signal activated when both clock and enable inputs are active.
    signal enable_clock: std_logic;
begin
    enable_clock <= enable and clock;

    l_initialize_flip_flops:
    for i in 0 to n - 1 generate
        flip_flop_instance: flip_flop_d_positive_edge port map(
            d => data(i),
            clock => enable_clock,
            q => result(i),
            q_not => open
        );
    end generate;

end architecture;
