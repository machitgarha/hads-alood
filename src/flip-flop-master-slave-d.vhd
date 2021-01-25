library ieee;
use ieee.std_logic_1164.all;

entity flip_flop_master_slave_d is
    port(
        d, clock: in std_logic;
        q, q_not: out std_logic
    );
end entity;

architecture structural of flip_flop_master_slave_d is
    component latch_gated_d is
        port(
            d, clock: in std_logic;
            q, q_not: out std_logic
        );
    end component;

    signal q_master: std_logic;
    signal clock_not: std_logic;
begin
    clock_not <= not clock;

    latch_master: latch_gated_d port map(d, clock, q_master, open);
    latch_slave: latch_gated_d port map(q_master, clock_not, q, q_not);
end architecture;
