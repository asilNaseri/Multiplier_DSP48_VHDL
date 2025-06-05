library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity Multiplier_tb is
    generic (
        A_Width  : natural;  
        B_Width  : natural;  
        C_Width  : natural;  
        output_width  : natural   
    );
end Multiplier_tb;

architecture behavior of Multiplier_tb is 

    
    component Multiplier
           port(
	      clk        : in std_logic;
		  A          : in signed(27 -1 downto 0);
		  B		     : in signed(18-1 downto 0);
		  C          : in signed(48-1 downto 0);
		  inputRdy   : in std_logic;
		  
		  P          : out signed(48-1 downto 0);
          outputRdy  : out std_logic		  
		 );
    end component;

    
    constant clk_period : time := 10 ns;

    
    signal clk       : std_logic;  
    signal A         : signed(27 - 1 downto 0); 
    signal B         : signed(18 - 1 downto 0); 
    signal C         : signed(48 - 1 downto 0);  
    signal inputRdy  : std_logic;  
	
    signal P         : signed(48 - 1 downto 0);  
    signal outputRdy : std_logic;  

 begin

   
    Multiplier_inst: Multiplier 
        port map (
            clk  => clk,
            A  => A,
            B  => B,
            C  => C,
            inputRdy  => inputRdy,
            P  => P,
            outputRdy => outputRdy
        );


    
 clk_gen : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
 end process;

reading : process 

        file input_file     : text open read_mode is "../test/input_data.txt";  
        variable dataLine   : line;  
        variable data       : integer;  
        variable temp_A   : integer;  
        variable temp_B   : integer;  
        variable temp_C   : signed(48 - 1 downto 0);
		
   begin
        
        while not endfile(input_file) loop
            readline(input_file, dataLine);  
            read(dataLine, data);      
            read(dataLine, temp_A);       
            read(dataLine, temp_B);      
            read(dataLine, temp_C);     

           
            inputRdy <= to_unsigned(data, 1)(0) after clk_period;
            A       <= to_signed(temp_A, A_Width) after clk_period;
            B       <= to_signed(temp_B, B_Width) after clk_period;
            C       <= temp_C	 after clk_period;

           
            wait for clk_period;
        end loop;

       
       wait;
end process;



writing : process(clk)
 
        file output_file    : text open write_mode is "../test/output_data.txt";  
        variable dataLine   : line;  
        variable data       : signed(48 - 1 downto 0);  
		
    begin
       if rising_edge(clk) then
          if outputRdy = '1' then
                data := P; 
                write(dataLine, data);  
                writeline(output_file, dataLine); 
          end if;
       end if;
end process;

end behavior;
