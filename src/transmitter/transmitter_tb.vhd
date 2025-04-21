library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmitter_tb is
end entity;

architecture transmitter_tb_arch of transmitter_tb is

    component transmitter is
        port (
            clk_i           : in  std_logic;  
            rst_i           : in  std_logic;  
            data_i          : in  std_logic_vector(7 downto 0); 
            wr_i            : in  std_logic;  
            wr_o            : out std_logic; 
            data_o          : out std_logic_vector(7 downto 0)   
        );
    end component transmitter;

    signal clk_tb           : std_logic := '0';
    signal rst_tb           : std_logic := '1';
    signal data_tb          : std_logic_vector(7 downto 0) := (others => '0');
    signal wr_tb            : std_logic := '0'; 
    signal wr_o_tb          : std_logic;
    signal data_o_tb        : std_logic_vector(7 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Generación del reloj
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    DUT : transmitter
        port map (
            clk_i   => clk_tb,
            rst_i   => rst_tb,
            data_i  => data_tb,
            wr_i    => wr_tb,
            wr_o    => wr_o_tb,
            data_o  => data_o_tb
        );

    -- Estímulos de prueba
    wr_process : process
    begin
        -- Inicialización
        wait for 20 ns;
        rst_tb <= '0';

        data_tb <= "00000001";  -- Data 1.
        wr_tb   <= '1';         -- Enable write trigger.
        wait for clk_period;    -- Wait a cycle

        -- Desactiva el trigger
        wr_tb <= '0';
        wait for 20 ns;

        data_tb <= "00000010"; 
        wr_tb <= '1';      
        wait for clk_period;

        wr_tb <= '0';
        wait for 20 ns;

        wait;
    end process;

end architecture;
