library ieee;
use ieee.std_logic_1164.all;

entity test_comparator_8_bit is
end entity;

architecture structural of test_comparator_8_bit is
    component comparator_n_bit is
        generic(
            constant n: integer
        );
        port(
            left_operand, right_operand: in std_logic_vector(n - 1 downto 0);
            lt, eq, gt: out std_logic
        );
    end component;

    constant n: integer := 8;

    -- lhs: Left-hand-side; rhs: Right-hand size
    signal lhs_op, rhs_op: std_logic_vector(n - 1 downto 0);
    signal lower_than, equals, greater_than: std_logic;
begin
    uut: comparator_n_bit generic map(n => n) port map(
        left_operand => lhs_op,
        right_operand => rhs_op,
        lt => lower_than,
        eq => equals,
        gt => greater_than
    );

    lhs_op <=
        x"2C" after 10 ns,
        x"09" after 20 ns,
        x"51" after 30 ns,
        x"D3" after 40 ns,
        x"2D" after 50 ns,
        x"02" after 60 ns,
        x"64" after 70 ns,
        x"00" after 80 ns;

    rhs_op <=
        x"47" after 10 ns,
        x"C3" after 20 ns,
        x"90" after 30 ns,
        x"BD" after 40 ns,
        x"2D" after 50 ns,
        x"01" after 60 ns,
        x"3C" after 70 ns,
        x"00" after 80 ns;

end architecture;
