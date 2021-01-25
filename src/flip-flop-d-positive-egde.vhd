library ieee;
use ieee.std_logic_1164.all;

-- Positive-edge-triggered D flip-flop
entity flip_flop_d_positive_edge is
    port(
        d, clock: in std_logic;
        q, q_not: out std_logic
    );
end entity;

architecture structural of flip_flop_d_positive_edge is
begin

end architecture;
