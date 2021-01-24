library ieee;
use ieee.std_logic_1164.all;

entity comparator_1_bit is
    port(
        in_1, in_2: in std_logic;

        -- Just like a decoder, exactly one of the followings will be 1.
        lt: out std_logic;
        eq: out std_logic;
        gt: out std_logic
    );
end entity;
