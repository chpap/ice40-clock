library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock is
  port (clk : in std_logic;
        digit1, digit2, digit3, digit4, digit5, digit6 : out std_logic_vector(3 downto 0);
        point1, point2, point3 : out std_logic
       );
end clock;

architecture rtl of clock is
  signal clk_4hz: std_logic;
  signal leds : std_ulogic_vector (1 to 3) := "100";
begin
  digit1 <= "0001";
  digit2 <= "0010";
  digit3 <= "0011";
  digit4 <= "0100";
  digit5 <= "0101";
  digit6 <= "0111";
  (point1, point2, point3) <= leds;


  process (clk)
    --  3_000_000 is 0x2dc6c0
    variable counter : unsigned (23 downto 0);
  begin
    if rising_edge(clk) then
      if counter = 2_999_999 then
        counter := x"000000";
        clk_4hz <= '1';
      else
        counter := counter + 1;
        clk_4hz <= '0';
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) and clk_4hz = '1' then
        --  Rotate
      leds <= (leds (3), leds (1), leds (2));
    end if;
  end process;
end rtl;
