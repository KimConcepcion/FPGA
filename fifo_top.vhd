----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2017 12:34:23
-- Design Name: Mads Villadsen, Kim Petersen og Kim C. Nielsen
-- Module Name: fifo_top - Behavioral
-- Project Name: LAB4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo_top is
    port(
        clk : std_logic;
        reset : std_logic;
        btn : std_logic_vector(1 downto 0);
        sw: std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(7 downto 0);
        an: out std_logic_vector(3 downto 0) 
    );
end fifo_top;

architecture Behavioral of fifo_top is
  signal db_btn: std_logic_vector(1 downto 0);
  signal status : std_logic_vector(3 downto 0);
  signal read_data : std_logic_vector(3 downto 0);
  signal write_data : std_logic_vector(3 downto 0);
begin

  -- debounce circuit for btn(0)
  btn_db_unit0: entity work.debounce
     port map(clk=>clk, reset=>reset, sw=>btn(0),
              db_level=>open, db_tick=>db_btn(0));
  -- debounce circuit for btn(1)
  
  btn_db_unit1: entity work.debounce
     port map(clk=>clk, reset=>reset, sw=>btn(1),
              db_level=>open, db_tick=>db_btn(1));
              
  -- instantiate a 2^2-by-3 fifo)
  fifo_unit: entity work.fifo(arch)
     generic map(B=>4, W=>3)
     port map(clk=>clk, reset=>reset,
              rd=>db_btn(0), wr=>db_btn(1),
              w_data=>sw, r_data=>read_data,
              full=>sseg(7), empty=>sseg(6));
  
   disp_unit: entity work.disp_hex_mux
   port map
   (
       clk => clk,
       reset => reset,
       hex0 => status,
       hex1 => read_data,
       hex2 => "0000",  
       hex3 => sw,
       dp_in => "0000",
       an => an,
       sseg => sseg
   );              
   
   
    
  -- disable unused leds
  sseg(5 downto 3)<=(others=>'0');
  end;