library ieee;
use ieee.std_logic_1164.all;

entity led_controller is
    port(
        lt, eq, gt, enable: in std_logic;
        led_correct, led_upper, led_less, led_lock: out std_logic
    );
end entity;

architecture structural of led_controller is
begin
    led_correct <= eq;
    led_upper <= gt;
    led_less <= lt;
    led_lock <= not enable;
end architecture;
