library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity crc8_system_VIO is
    port(
        clk_i : in std_logic
    );
end entity;

architecture crc8_system_VIO_arch of crc8_system_VIO is
    
    component crc8_system is
        port (
            clk_i        : in  std_logic;
            rst_i        : in  std_logic;
            data_i       : in  std_logic_vector(7 downto 0);
            wr_i         : in  std_logic;
            clear_crc_i  : in  std_logic;
            crc_o        : out std_logic_vector(7 downto 0)
        );
    end component;

    signal probe_rst, probe_wr, probe_clear_crc : std_logic_vector(0 downto 0);
    signal probe_crc, probe_data : std_logic_vector(7 downto 0);

begin

    crc8_system_inst: crc8_system
        port map(
            clk_i        => clk_i,
            rst_i        => probe_rst(0),
            data_i       => probe_data,
            wr_i         => probe_wr(0),
            clear_crc_i  => probe_clear_crc(0),
            crc_o        => probe_crc
        );

end architecture;