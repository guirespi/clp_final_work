library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crc8_system_tb is
end entity;

architecture crc8_system_tb_arch of crc8_system_tb is
    component crc8_system
        port (
            clk_i        : in  std_logic;
            rst_i        : in  std_logic;
            data_i       : in  std_logic_vector(7 downto 0);
            wr_i         : in  std_logic;
            crc_o        : out std_logic_vector(7 downto 0)
        );
    end component;
    

    signal clk_tb       : std_logic := '0';
    signal rst_tb       : std_logic := '0';
    signal data_tb      : std_logic_vector(7 downto 0) := (others => '0');
    signal wr_tb        : std_logic := '0';
    signal crc_tb       : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin

    DUT: crc8_system
        port map (
            clk_i       => clk_tb,
            rst_i       => rst_tb,
            data_i      => data_tb,
            wr_i        => wr_tb,
            crc_o       => crc_tb
        );

    -- Clock generator
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Write process
    write_process : process
        procedure write_byte(b : std_logic_vector(7 downto 0)) is
        begin
            data_tb <= b;
            wr_tb <= '1';  
            wait for clk_period;
            wr_tb <= '0'; 
            wait for clk_period;
            wait for clk_period;
            end procedure;
    begin
        -- Initial reset
        rst_tb <= '1';
        wait for clk_period;
        rst_tb <= '0';
        wait for clk_period;

        -- Data stream: 0x12 0x34 0x56 0x78
        write_byte(x"AA");
        write_byte(x"BB");
        write_byte(x"CC");
        write_byte(x"DD");

        -- Clear crc
        rst_tb <= '1';
        wait for clk_period;
        rst_tb <= '0';
        wait for clk_period;

        -- End simulation
        wait;
    end process;
end architecture;
