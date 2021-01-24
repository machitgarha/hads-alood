library ieee;
use ieee.std_logic_1164.all;

entity comparator_n_bit is
    generic(
        constant n: integer
    );
    port(
        left_operand, right_operand: in std_logic_vector(n - 1 downto 0);

        -- Just like a decoder, exactly one of the followings will be 1.
        -- lt: Lower-than
        -- eq: Equals
        -- gt: Greater-than
        lt, eq, gt: out std_logic
    );
end entity;
