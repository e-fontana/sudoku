	component unsaved is
		port (
			clk_clk                        : in  std_logic                     := 'X';             -- clk
			reset_reset_n                  : in  std_logic                     := 'X';             -- reset_n
			uart_0_reset_reset_n           : in  std_logic                     := 'X';             -- reset_n
			uart_0_s1_address              : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			uart_0_s1_begintransfer        : in  std_logic                     := 'X';             -- begintransfer
			uart_0_s1_chipselect           : in  std_logic                     := 'X';             -- chipselect
			uart_0_s1_read_n               : in  std_logic                     := 'X';             -- read_n
			uart_0_s1_write_n              : in  std_logic                     := 'X';             -- write_n
			uart_0_s1_writedata            : in  std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			uart_0_s1_readdata             : out std_logic_vector(15 downto 0);                    -- readdata
			uart_0_irq_irq                 : out std_logic;                                        -- irq
			uart_0_external_connection_rxd : in  std_logic                     := 'X';             -- rxd
			uart_0_external_connection_txd : out std_logic                                         -- txd
		);
	end component unsaved;

	u0 : component unsaved
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                        clk.clk
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                      reset.reset_n
			uart_0_reset_reset_n           => CONNECTED_TO_uart_0_reset_reset_n,           --               uart_0_reset.reset_n
			uart_0_s1_address              => CONNECTED_TO_uart_0_s1_address,              --                  uart_0_s1.address
			uart_0_s1_begintransfer        => CONNECTED_TO_uart_0_s1_begintransfer,        --                           .begintransfer
			uart_0_s1_chipselect           => CONNECTED_TO_uart_0_s1_chipselect,           --                           .chipselect
			uart_0_s1_read_n               => CONNECTED_TO_uart_0_s1_read_n,               --                           .read_n
			uart_0_s1_write_n              => CONNECTED_TO_uart_0_s1_write_n,              --                           .write_n
			uart_0_s1_writedata            => CONNECTED_TO_uart_0_s1_writedata,            --                           .writedata
			uart_0_s1_readdata             => CONNECTED_TO_uart_0_s1_readdata,             --                           .readdata
			uart_0_irq_irq                 => CONNECTED_TO_uart_0_irq_irq,                 --                 uart_0_irq.irq
			uart_0_external_connection_rxd => CONNECTED_TO_uart_0_external_connection_rxd, -- uart_0_external_connection.rxd
			uart_0_external_connection_txd => CONNECTED_TO_uart_0_external_connection_txd  --                           .txd
		);

