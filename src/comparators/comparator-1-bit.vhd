library ieee;
use ieee.std_logic_1164.all;

entity comparator_1_bit is
    port(
        left_operand, right_operand: in std_logic;

        -- Just like a decoder, exactly one of the followings will be 1.
        -- lt: Lower-than
        -- eq: Equals
        -- gt: Greater-than
        lt, eq, gt: out std_logic
    );
end entity;

architecture structural of comparator_1_bit is
begin
    lt <= not left_operand and right_operand;
    eq <= not (left_operand xor right_operand);
    gt <= left_operand and not right_operand;
end architecture;
