library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crc8_system is
    port (
        clk_i        : in  std_logic;
        rst_i        : in  std_logic;
        data_i       : in  std_logic_vector(7 downto 0);
        wr_i         : in  std_logic;
        clear_crc_i  : in  std_logic;
        crc_o        : out std_logic_vector(7 downto 0)
    );
end entity;

architecture crc8_system_arch of crc8_system is

    -- Señales internas
    signal wr_signal  : std_logic;
    signal data_bus       : std_logic_vector(7 downto 0);

    -- Componente: Transmitter
    component transmitter
        port (
            clk_i    : in  std_logic;
            rst_i    : in  std_logic;
            data_i   : in  std_logic_vector(7 downto 0);
            wr_i     : in  std_logic;
            wr_o     : out std_logic;
            data_o   : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Componente: CRC8 Register
    component crc8_smbus
        port (
            clk_i        : in  std_logic;
            rst_i        : in  std_logic;
            data_i       : in  std_logic_vector(7 downto 0);
            wr_i         : in  std_logic;
            clear_crc_i  : in  std_logic;
            crc_o        : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    
    -- Instancia del transmisor
    tx_inst : transmitter
        port map (
            clk_i   => clk_i,
            rst_i   => rst_i,
            data_i  => data_i,
            wr_i    => wr_i,
            wr_o    => wr_signal,
            data_o  => data_bus
        );

    -- Instancia del CRC8
    crc_inst : crc8_smbus
        port map (
            clk_i        => clk_i,
            rst_i        => rst_i,
            data_i       => data_bus,
            wr_i         => wr_signal,
            clear_crc_i  => clear_crc_i,
            crc_o        => crc_o
        );

end architecture;
