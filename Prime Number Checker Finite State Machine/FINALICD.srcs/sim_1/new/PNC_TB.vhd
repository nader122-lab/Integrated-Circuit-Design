----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2021 17:50:15
-- Design Name: 
-- Module Name: PNC_TB - Behavioral
-- Project Name: 
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

entity PNC_TB is
end PNC_TB;

architecture Behavioral of PNC_TB is

component Pnc_FSM is
    Port ( 
           CLK : in STD_LOGIC;
           Input : in STD_LOGIC_VECTOR(7 downto 0);
           UserGuess: out STD_LOGIC;
           PrimeLed:  out STD_LOGIC;
           GuessResult : out STD_LOGIC;
           Led4 : out STD_logic_vector(3 downto 0)           
           );
end component;
signal CLK, UserGuess, PrimeLed, GuessResult: std_logic;
signal Input : std_logic_vector(7 downto 0);
signal Led4 : std_logic_vector(3 downto 0); 
 
begin
UUT : Pnc_FSM port map(CLK => CLK, Input => Input, UserGuess => UserGuess, PrimeLed => PrimeLed, GuessResult => GuessResult, Led4 => Led4);
clk_proc: process --process simulating the clock cycle
begin
 CLK <= '0';
 wait for 50 ns;
 CLK <= '1';
 wait for 50 ns;
end process clk_proc;

sim_proc: process --process simulating resets and different input combinations
begin

Input <= "10000000"; wait for 2000ns; --reset HIGH
Input <= "00001101"; wait for 2000ns; --input number 13 with user guessing not prime
Input <= "10000000"; wait for 2000ns; --reset HIGH
Input <= "00110001"; wait for 2000ns; --input number 49 with user guessing not prime
Input <= "10000000"; wait for 2000ns; --reset HIGH
Input <= "00001111"; wait for 2000ns; --input number 15 with user guessing not prime
Input <= "10000000"; wait for 2000ns; --reset HIGH
Input <= "01010000"; wait for 2000ns; --input number 16 with user guessing prime
Input <= "10000000"; wait for 2000ns; --reset HIGH
Input <= "00010011"; wait for 2000ns; --input number 19 with user guessing not prime


end process sim_proc;
end Behavioral;
