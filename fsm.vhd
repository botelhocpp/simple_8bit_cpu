----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: fsm
-- Project Name: Simple 8-bit CPU
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: (Mealy) Finite state machine of the controller.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fsm IS
    PORT (
        -- Inputs
        opcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        zero : IN STD_LOGIC;
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
		rd : OUT STD_LOGIC;
		wr : OUT STD_LOGIC;
		ld_ir : OUT STD_LOGIC;
		ld_ac : OUT STD_LOGIC;
		ld_pc : OUT STD_LOGIC;
		inc_pc : OUT STD_LOGIC;
		halt : OUT STD_LOGIC;
		data_e : OUT STD_LOGIC;
		sel : OUT STD_LOGIC
    );
END fsm;

ARCHITECTURE hardware OF fsm IS
    TYPE states_t IS (
        INST_ADDR,
        INST_FETCH,
        INST_LOAD,
        IDLE,
        OP_ADDR,
        OP_FETCH,
        ALU_OP,
        STORE
    );
    SIGNAL current_state : states_t;
    
BEGIN  
    -- States Logic
    PROCESS(clk, rst)
    BEGIN
        IF(rst = '1') THEN
            current_state <= INST_ADDR;
        ELSIF(RISING_EDGE(clk)) THEN
            CASE current_state IS
                WHEN INST_ADDR =>
                    current_state <= INST_FETCH;
                    
                WHEN INST_FETCH =>
                    current_state <= INST_LOAD;
                
                WHEN INST_LOAD =>
                    current_state <= IDLE;
                
                WHEN IDLE =>
                    current_state <= OP_ADDR;
                
                WHEN OP_ADDR =>
                    current_state <= OP_FETCH;
                
                WHEN OP_FETCH =>
                    current_state <= ALU_OP;
                
                WHEN ALU_OP =>
                    current_state <= STORE;
                
                WHEN STORE =>
                    current_state <= INST_ADDR;
                
                WHEN OTHERS =>
                
            END CASE;
        END IF;
    END PROCESS;
    
    -- Output Logic
    PROCESS(current_state, opcode)
    BEGIN
    	rd <= '0';
		wr <= '0';
		ld_ir <= '0';
		ld_ac <= '0';
		ld_pc <= '0';
		inc_pc <= '0';
		halt <= '0';
		data_e <= '0';
		sel <= '0';
		
        CASE current_state IS
            WHEN INST_ADDR =>
                sel <= '1';

            WHEN INST_FETCH =>
                sel <= '1';
                rd <= '1';

            WHEN INST_LOAD =>
                sel <= '1';
                rd <= '1';
                ld_ir <= '1';

            WHEN IDLE =>
                sel <= '1';
                rd <= '1';
                ld_ir <= '1';

            WHEN OP_ADDR =>
                inc_pc <= '1';
                IF (opcode = "000") THEN
                    halt <= '1';
                END IF;

            WHEN OP_FETCH =>
                IF(opcode = "010" OR opcode = "011" OR opcode = "100" OR opcode = "101") THEN
                    rd <= '1';
                END IF;

            WHEN ALU_OP =>
                IF (opcode = "010" OR opcode = "011" OR opcode = "100" OR opcode = "101") THEN
                    rd <= '1';
                END IF;
                
                IF (opcode = "001" AND zero = '1') THEN
                    inc_pc <= '1';
                END IF;
                
                IF (opcode = "111") THEN
                    ld_pc <= '1';
                END IF;
                
                IF (opcode = "110") THEN
                    data_e <= '1';
                END IF;
                
            WHEN STORE =>
                IF (opcode = "010" OR opcode = "011" OR opcode = "100" OR opcode = "101") THEN
                    rd <= '1';
                    ld_ac <= '1';
                END IF;
                
                IF (opcode = "111") THEN
                    ld_pc <= '1';
                END IF;
                
                IF (opcode = "110") THEN
                    data_e <= '1';
                    wr <= '1';
                END IF;
                
            WHEN OTHERS =>
            
        END CASE;
    END PROCESS;
END hardware;