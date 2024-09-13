----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: memory
-- Project Name: Simple 8-bit CPU
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Unified RAM memory with intructions and data.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY memory IS
    GENERIC (
        N : INTEGER := 8;
        Q : INTEGER := 5
    );
    PORT (
        data : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        addr : IN STD_LOGIC_VECTOR(Q - 1 DOWNTO 0);
        clk : IN STD_LOGIC;
        rd : IN STD_LOGIC;
        wr : IN STD_LOGIC
    );
END memory;

ARCHITECTURE hardware OF memory IS
    TYPE mem_array_t IS ARRAY (0 TO 2**Q - 1) OF STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL ram_contents : mem_array_t := (
        -- Code:
        0 => "10110000", -- 0: LDA 16
        1 => "01010001", -- 1: ADD 17
        2 => "11010010", -- 2: STO 18
        3 => "10010011", -- 3: XOR 19
        4 => "00100000", -- 4: SKZ
        5 => "11100000", -- 5: JMP 0
        6 => "11101001", -- 6: JMP 9
        7 => "10110000", -- 7: LDA 16
        8 => "11010100", -- 8: STO 20
        9 => "00000000", -- 9: HLT
        
        -- Data:
        16 => "00000110", -- 16: 0x06
        17 => "00000010", -- 17: 0x02
        18 => "00000000", -- 18: 0x00
        19 => "00001000", -- 19: 0x08
        OTHERS => "00000000"
    );
BEGIN    
    PROCESS(clk)
    BEGIN
        IF(RISING_EDGE(clk)) THEN
            IF(wr = '1') THEN
                ram_contents(TO_INTEGER(UNSIGNED(addr(Q - 1 DOWNTO 0)))) <= data;
            ELSIF(rd = '1') THEN
                data <= ram_contents(TO_INTEGER(UNSIGNED(addr(Q - 1 DOWNTO 0))));
            ELSE
                data <= (OTHERS => 'Z');
            END IF;
        END IF;
    END PROCESS;
END hardware;