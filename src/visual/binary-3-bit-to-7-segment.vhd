library ieee;
use ieee.std_logic_1164.all;

entity binary_3_bit_to_7_segment is
    port(
        data: in std_logic_vector(2 downto 0);
        result_7_segment: out std_logic_vector(6 downto 0)
    );
end entity;

architecture structural of binary_3_bit_to_7_segment is
begin
    with data select
        result_7_segment <=
            "1111110" when o"0",
            "0110000" when o"1",
            "1101101" when o"2",
            "1111001" when o"3",
            "0110011" when o"4",
            "1011011" when o"5",
            "1011111" when o"6",
            "1110000" when o"7",
            -- Turn off in the case of any errors
            (others => '0') when others;
end architecture;
