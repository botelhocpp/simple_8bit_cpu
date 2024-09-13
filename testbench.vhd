----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: testbench
-- Project Name: Simple 8-bit CPU
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: A simple testbench for simulation of the CPU.
-- 
-- Dependencies: cpu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE hardware OF testbench IS
    CONSTANT N : INTEGER := 8;
    CONSTANT Q : INTEGER := 5;
    CONSTANT CLK_FREQ : INTEGER := 50e6;
    CONSTANT CLK_PERIOD : TIME := 5000ms / CLK_FREQ;

    COMPONENT cpu IS
    GENERIC (
        N : INTEGER := N;
        Q : INTEGER := Q
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC
    );
    END COMPONENT;
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
BEGIN
    CPU_COMP : cpu PORT MAP (
        clk => clk,
        rst => rst
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR CLK_PERIOD/2;
        
        rst <= '0';
        WAIT FOR 70*CLK_PERIOD;
    END PROCESS;
END hardware;
