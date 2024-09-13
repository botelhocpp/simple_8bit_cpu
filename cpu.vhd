----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: cpu
-- Project Name: Simple 8-bit CPU
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The internal interconnection of the CPU components.
-- 
-- Dependencies: generic_register, counter, alu, memory, fsm
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY cpu IS
    GENERIC (
        N : INTEGER := 8;
        Q : INTEGER := 5
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC
    );
END cpu;

ARCHITECTURE hardware OF cpu IS
    
    COMPONENT alu IS
    GENERIC ( N : INTEGER := N );
    PORT (
        A : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        op : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        zero : OUT STD_LOGIC
    );
    END COMPONENT;
    
    COMPONENT generic_register IS
    GENERIC ( N : INTEGER := N );
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT counter IS
    GENERIC ( N : INTEGER := Q );
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        ld : IN STD_LOGIC;
        inc : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT memory IS
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
    END COMPONENT;
    
    COMPONENT fsm IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        zero : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
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
    END COMPONENT;
    
    SIGNAL ac_output : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL ir_output : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    
    SIGNAL pc_addr : STD_LOGIC_VECTOR(Q - 1 DOWNTO 0);
    
    SIGNAL data_bus : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL alu_bus : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL alu_zero : STD_LOGIC;
    
    SIGNAL opcode : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ir_addr : STD_LOGIC_VECTOR(Q - 1 DOWNTO 0);
    SIGNAL addr : STD_LOGIC_VECTOR(Q - 1 DOWNTO 0);
    
    SIGNAL rd : STD_LOGIC;
    SIGNAL wr : STD_LOGIC;
    SIGNAL sel : STD_LOGIC;
    SIGNAL ld_ir : STD_LOGIC;
    SIGNAL halt : STD_LOGIC;
    SIGNAL inc_pc : STD_LOGIC;
    SIGNAL ld_ac : STD_LOGIC;
    SIGNAL ld_pc : STD_LOGIC;
    SIGNAL data_e : STD_LOGIC;
    
    SIGNAL sys_clock : STD_LOGIC;
    
BEGIN    
    AC_OP : generic_register
    PORT MAP (
        D => alu_bus,
        ld => ld_ac,
        clk => sys_clock,
        rst => rst,
        Q => ac_output
    );  
    PC_OP : counter
    PORT MAP (
        D => ir_addr,
        ld => ld_pc,
        inc => inc_pc,
        clk => sys_clock,
        rst => rst,
        Q => pc_addr
    );  
    IR_OP : generic_register
    PORT MAP (
        D => data_bus,
        ld => ld_ir,
        clk => sys_clock,
        rst => rst,
        Q => ir_output
    );
    ALU_OP : alu PORT MAP (
        A => ac_output,
        B => data_bus,
        op => opcode,
        Q => alu_bus,
        zero => alu_zero
    );
    MEM_OP : memory PORT MAP (
        data => data_bus,
        addr => addr,
        clk => sys_clock,
        rd => rd,
        wr => wr
    );
    FSM_OP : fsm PORT MAP (
        clk => sys_clock,
        rst => rst,
        zero => alu_zero,
        opcode => opcode,
        sel => sel,
        rd => rd,
        ld_ir => ld_ir,
        halt => halt,
        inc_pc => inc_pc,
        ld_ac => ld_ac,
        wr => wr,
        ld_pc => ld_pc,
        data_e => data_e
    );
    
    -- IR Output Signals
    opcode <= ir_output(7 DOWNTO 5);
    ir_addr <= ir_output(4 DOWNTO 0);
    
    -- Buffer
    data_bus <= (alu_bus) WHEN (wr = '1') ELSE (OTHERS => 'Z');
    
    -- Mux
    addr <= (ir_addr) WHEN (sel = '0') ELSE (pc_addr);
    
    -- Clock Enable
    sys_clock <= clk AND (NOT halt);
END hardware;