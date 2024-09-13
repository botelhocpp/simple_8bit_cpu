----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: alu
-- Project Name: Simple 8-bit CPU
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Arithmetic and Logic unit of the CPU.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        A : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        op : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        zero : OUT STD_LOGIC
    );
END alu;

ARCHITECTURE hardware OF alu IS
    SIGNAL res : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL add_res : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    CONSTANT ZERO_CONST : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    -- ALU result
    Q <= res;
    add_res <= STD_LOGIC_VECTOR(UNSIGNED(A) + UNSIGNED(B));
    
    -- ALU Mux
    WITH op SELECT
    res <=  (A)          WHEN "000",
            (A)          WHEN "001",
            (add_res)    WHEN "010",
            (A AND B)    WHEN "011",
            (A XOR B)    WHEN "100",
            (B)          WHEN "101",
            (A)          WHEN "110",
            (A)          WHEN "111",
            (OTHERS => '0')  WHEN OTHERS;
    
    -- Flag
    zero <= '1' WHEN (res = ZERO_CONST) ELSE '0';
END hardware;