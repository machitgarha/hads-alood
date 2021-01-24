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

architecture structural of comparator_n_bit is
    component comparator_1_bit is
        port(
            left_operand, right_operand: in std_logic;
            lt, eq, gt: out std_logic
        );
    end component;

    -- Signals for keeping the results of bit-to-bit comparisons, using comparator_1_bit
    signal lt_bits, eq_bits, gt_bits: std_logic_vector(n - 1 downto 0);

    -- A vector of '1's
    signal one_bits: std_logic_vector(n - 1 downto 0);

    -- Signals used for saving results of smaller blocks of greater-than comparison
    -- operation, consisting of many and and or gates.
    signal gt_and_results, gt_or_results: std_logic_vector(n - 1 downto 0);

    -- Temporary signals saving the eq and gt results, to be used in lower-than output.
    signal eq_tmp, gt_tmp: std_logic;
begin
    l_one_on_one_bits_comparison:
    for i in 0 to n - 1 generate
        comparator_1_bit_i: comparator_1_bit port map(
            left_operand => left_operand(i),
            right_operand => right_operand(i),

            lt => lt_bits(i),
            eq => eq_bits(i),
            gt => gt_bits(i)
        );
    end generate;

    -- This could be merged with the previous generate loop, but it is here to keep
    -- things separated and clean. This should not affect performance in any way, as
    -- generate is a analyze-time (i.e. compile-time) operation.
    l_initialize_one_bits:
    for i in 0 to n - 1 generate
        one_bits(i) <= '1';
    end generate;

    eq_tmp <= '1' when eq_bits = one_bits else '0';

    gt_or_results(0) <= gt_bits(0);

    -- TODO: Document this?
    l_initialize_gt_blocks:
    for i in 0 to n - 2 generate
        gt_and_results(i) <= gt_or_results(i) and eq_bits(i + 1);
        gt_or_results(i + 1) <= gt_and_results(i) or gt_bits(i + 1);
    end generate;

    gt_tmp <= gt_or_results(n - 1);

    -- Lower-than is just the opposite of greater-than or equals. We could implement it
    -- just like greater-than, but this way it avoids code duplication, making its chip
    -- (i.e. physical block) smaller and the code more maintainable, while having a small
    -- extra delay.
    lt <= gt_tmp nor eq_tmp;
    eq <= eq_tmp;
    gt <= gt_tmp;

end architecture;
