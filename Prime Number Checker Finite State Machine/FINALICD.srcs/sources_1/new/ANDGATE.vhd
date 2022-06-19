----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2021 14:44:29
-- Design Name: 
-- Module Name: ANDGATE - Behavioral
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pnc_FSM is
    Port ( 
           CLK : in STD_LOGIC;
           Input : in STD_LOGIC_VECTOR(7 downto 0);
           UserGuess: out STD_LOGIC;
           PrimeLed:  out STD_LOGIC;
           GuessResult : out STD_LOGIC;
           Led4 : out STD_logic_vector(3 downto 0)           
           );
end Pnc_FSM;

architecture FSM of Pnc_FSM is
type state_type is (DEFAULT1,DEFAULT2, ModOp, INIT ,A1, A2, A3, isPrime, notPrime); --states associated with the finite state machine
SIGNAL STATE : STATE_TYPE; 
SIGNAL NSTATE : STATE_TYPE; 
SIGNAL TEMP : INTEGER;
SIGNAL R : INTEGER;
SIGNAL D : INTEGER := 2;
begin

     SYNC_PROC : PROCESS(CLK, Input(7)) --process that synchronises the state machine process
      BEGIN 
      
                 
           IF (Input(7) = '1') THEN  --checks if RESET is HIGH 
             STATE <= DEFAULT1;                         
           ELSIF (CLK'EVENT AND CLK = '1') THEN  --sets current state to next state value
             STATE <= NSTATE; 
           END IF;                 
            
     

     END PROCESS SYNC_PROC;   
       
     STATE_PROC: PROCESS(STATE, Input)
       BEGIN
                         
         TEMP <= to_integer(unsigned(Input(5 downto 0))); --converts binary input to integer for mod operation
                       
         CASE STATE IS
             
         WHEN DEFAULT1 =>  --initial state when reset is set HIGH   
               NSTATE <= DEFAULT2;          
               PrimeLed <= '1';
               GuessResult <= '1';
               if(input(6) = '1') then -- Users prime guess is evaluated
                UserGuess <= '1';
               end if;
               if(input(6) = '0') then 
                UserGuess <= '0';          
               end if;
               
         WHEN DEFAULT2 =>   --checks for error input cases    
               if(input(6) = '1') then 
                UserGuess <= '1';
               end if;
               
               if(input(6) = '0') then 
                UserGuess <= '0';          
               end if;
             
               Led4 <= "0000";
               PrimeLed <= '0';
               GuessResult <= '0';
               
               NSTATE <= ModOp;
               D <= 2;
               
               if (TEMP = 1 or TEMP = 0) then
                NSTATE <= notPrime;
                Led4 <= "0000";     
               END IF;          
                                                         
               if (TEMP = 2) then
                NSTATE <= isPrime;
                Led4 <= "0000";     
               END IF; 
               
               if (TEMP = 3) then
                NSTATE <= isPrime;
                Led4 <= "0000";     
               END IF; 
               
               if (TEMP = 5) then
                NSTATE <= isPrime;
                Led4 <= "0000";     
               END IF; 
               
               if (TEMP = 7) then
                NSTATE <= isPrime;
                Led4 <= "0000";     
               END IF;                
               
          WHEN ModOp  =>  --mod operation of input TEMP is completed 
               R <= TEMP mod D;
               if(D <= 2) then
                NSTATE <= INIT;
               elsif(D <= 3) then
                NSTATE <= A1;
               elsif(D <= 5) then
                NSTATE <= A2;
               elsif(D <= 7) then
                NSTATE <= A3;                      
               END IF;
               
          WHEN INIT => --evaluates case for divisor = 2
                    
               if (R = 0) then
                Led4 <= "0010";
                NSTATE <= notPrime;                         
               ELSIF (R /= 0) then 
                D <= 3;             
                NSTATE <= ModOp;   
               END IF; 
              
              
              
          WHEN A1 => --evaluates case for divisor = 3
               IF (R = 0) then
                Led4 <= "0011";
                NSTATE <= notPrime;                                
               ELSIF (R /= 0) then  
                D <= 5;
                NSTATE <= ModOp;                                     
               END IF;
               
                 

          WHEN A2 => --evaluates case for divisor = 5
               if (R = 0) then
                Led4 <= "0101";
                NSTATE <= notPrime;
               ELSIF (R /= 0) then   
                D <= 7;   
                NSTATE <= ModOp;                                     
               END IF;
               

               
         WHEN A3 => --evaluates case for divisor = 7
              IF (R = 0) then
               Led4 <= "0111";
               NSTATE <= notPrime;                                     
              ELSIF (R /= 0) then
               NSTATE <= isPrime;
              END IF;
               
     
         WHEN isPrime => --prime number successfully 
              if(Input(6) = '1') then --correct guess
               PrimeLed <= '1';
               GuessResult <= '1';
              else                    --incorrect guess
               GuessResult <= '0';
               PrimeLed <= '1';
              end if;  
            
           
         WHEN notPrime => --not prime successfully detected
              if(Input(6) = '1') then --incorrect guess
               GuessResult <= '0';
               PrimeLed <= '0';
              else                  --correct guess
               Primeled <= '0';     
               GuessResult <= '1';        
              end if;          
            
         WHEN others =>
                
         END CASE;     
               
               
      END PROCESS STATE_PROC;     

END FSM;
