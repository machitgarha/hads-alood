library ieee;
use ieee.std_logic_1164.all;

entity latch_gated_d is
    port(
        d, clock: in std_logic;
        q, q_not: out std_logic
    );
end entity;
