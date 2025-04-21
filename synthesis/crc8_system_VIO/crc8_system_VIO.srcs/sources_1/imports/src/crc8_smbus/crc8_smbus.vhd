library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity crc8_smbus is
    port (
        clk_i       : in  std_logic;
        rst_i       : in  std_logic;
        data_i      : in  std_logic_vector(7 downto 0);
        wr_i        : in  std_logic;
        clear_crc_i : in  std_logic;
        crc_o       : out std_logic_vector(7 downto 0)
    );
end entity;

architecture crc8_smbus_arch of crc8_smbus is
    signal crc_reg     : std_logic_vector(7 downto 0) := (others => '0');
    signal wr_i_prev   : std_logic := '0';
    signal wr_edge     : std_logic := '0';
    signal crc_next    : std_logic_vector(7 downto 0);
begin

    -- 1. Detección de flanco de subida
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            wr_i_prev <= wr_i;
        end if;
    end process;

    wr_edge <= wr_i and not wr_i_prev;

    -- 2. Proceso secuencial: actualización del CRC
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' or clear_crc_i = '1' then
                crc_reg <= (others => '0');
            elsif wr_edge = '1' then
                crc_reg <= crc_next;
            end if;
        end if;
    end process;

    -- 3. Proceso combinacional: cálculo del CRC bit a bit
    process(crc_reg, data_i)
        variable crc_tmp : std_logic_vector(7 downto 0);
        variable din     : std_logic_vector(7 downto 0);
    begin
        crc_tmp := crc_reg;
        din := data_i;

        for i in 7 downto 0 loop
            if (crc_tmp(7) xor din(i)) = '1' then
                crc_tmp := (crc_tmp(6 downto 0) & '0') xor "00000111";
            else
                crc_tmp := (crc_tmp(6 downto 0) & '0');
            end if;
        end loop;

        crc_next <= crc_tmp;
    end process;

    -- Salida
    crc_o <= crc_reg;

end crc8_smbus_arch;
