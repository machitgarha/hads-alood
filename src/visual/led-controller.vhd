library ieee;
use ieee.std_logic_1164.all;

entity led_controller is
    port(
        lt, eq, gt, locked: in std_logic;
        led_correct, led_upper, led_less, led_lock: out std_logic;

        -- Enable is used when we want to hide LED results, e.g. because of an unstable
        -- state, and turn all of them off.
        enable: in std_logic := '1'
    );
end entity;

architecture structural of led_controller is
begin
    led_correct <= eq and enable;
    led_upper <= gt and enable;
    led_less <= lt and enable;
    led_lock <= locked and enable;
end architecture;
