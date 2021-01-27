library ieee;
use ieee.std_logic_1164.all;

entity latch_d_gated is
    port(
        d, clock: in std_logic;
        q, q_not: out std_logic
    );
end entity;

architecture structural of latch_d_gated is
    -- As it is not possible to connect an output port to an internal gate, we need
    -- separated connectors holding q and q_not values, connecting them to both internals
    -- and actual output ports (i.e. q and q_not).
    signal q_connector: std_logic := '0';
    signal q_not_connector: std_logic := '1';
begin
    q_connector <= d when clock = '1';
    q_not_connector <= not d when clock = '1';

    q <= q_connector;
    q_not <= q_not_connector;
end architecture;
