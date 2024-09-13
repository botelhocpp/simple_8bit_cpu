----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: counter
-- Project Name: Simple 8-bit CPU
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: A generic n-bit upwards counter.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS
    GENERIC ( N : INTEGER := 5 );
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        ld : IN STD_LOGIC;
        inc : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END counter;

ARCHITECTURE hardware OF counter IS
    SIGNAL data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN    
    Q <= data;
    PROCESS(rst, clk)
    BEGIN
        IF(rst = '1') THEN
            data <= (OTHERS => '0');
        ELSIF(RISING_EDGE(clk)) THEN
            IF(ld = '1') THEN
                data <= D;
            ELSIF(inc = '1') THEN
                data <= STD_LOGIC_VECTOR(UNSIGNED(data) + 1);
            END IF;
        END IF;
    END PROCESS;
END hardware;