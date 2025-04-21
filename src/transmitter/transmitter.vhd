library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity transmitter is
    port (
        clk_i    : in  std_logic;
        rst_i    : in  std_logic;
        data_i   : in  std_logic_vector(7 downto 0);
        wr_i     : in  std_logic;
        wr_o     : out std_logic;
        data_o   : out std_logic_vector(7 downto 0)
    );
end entity transmitter;

architecture transmitter_arch of transmitter is
    type state_t is (IDLE, WRITE, DONE);
    signal state_reg, state_next : state_t;

    -- Señales internas registradas
    signal wr_o_reg     : std_logic := '0';
    signal data_o_reg   : std_logic_vector(7 downto 0) := (others => '0');

    -- Señal para detectar flanco ascendente
    signal wr_i_prev : std_logic := '0';
    signal wr_edge   : std_logic;
begin

    -- Asignación a las salidas
    wr_o   <= wr_o_reg;
    data_o <= data_o_reg;

    -- Flanco ascendente en wr_i
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            wr_i_prev <= wr_i;
        end if;
    end process;

    wr_edge <= wr_i and not wr_i_prev;

    -- Proceso secuencial (registro de estado y salidas)
    process(clk_i, rst_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                state_reg   <= IDLE;
                wr_o_reg    <= '0';
                data_o_reg  <= (others => '0');
            else
                state_reg   <= state_next;

                -- Salidas registradas (solo se actualizan si es necesario)
                case state_next is
                    when IDLE =>
                        wr_o_reg   <= '0';
                        data_o_reg <= data_o_reg; -- Se mantiene

                    when WRITE =>
                        wr_o_reg   <= '1';
                        data_o_reg <= data_i;

                    when DONE =>
                        wr_o_reg   <= '0';  -- Asegura que el pulso sea de un solo ciclo
                        data_o_reg <= data_o_reg;
                end case;
            end if;
        end if;
    end process;

    -- Proceso combinacional (siguiente estado)
    process(state_reg, wr_edge)
    begin
        case state_reg is
            when IDLE =>
                if wr_edge = '1' then
                    state_next <= WRITE;
                else
                    state_next <= IDLE;
                end if;

            when WRITE =>
                state_next <= DONE;

            when DONE =>
                state_next <= IDLE;

            when others =>
                state_next <= IDLE;
        end case;
    end process;

end transmitter_arch;
