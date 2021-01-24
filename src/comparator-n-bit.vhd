library ieee;
use ieee.std_logic_1164.all;

entity comparator_n_bit is
    generic(
        constant n: integer;

        -- Mappings of different comparison results into logic signals. This means, for
        -- example, when the first number is lower than the second one, the output will be
        -- the same as lt_out constant.
        constant lt_out: std_logic_vector(1 downto 0) := "00";
        constant eq_out: std_logic_vector(1 downto 0) := "01";
        constant gt_out: std_logic_vector(1 downto 0) := "10"
    );
    port(
        x, y: in std_logic_vector(n - 1 downto 0);
        result: out std_logic_vector(1 downto 0)
    );
end entity;
