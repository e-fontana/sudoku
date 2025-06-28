	component communicator is
		port (
			rs232_0_UART_RXD        : in  std_logic                    := 'X';             -- RXD
			rs232_0_UART_TXD        : out std_logic;                                       -- TXD
			rs232_0_from_uart_ready : in  std_logic                    := 'X';             -- ready
			rs232_0_from_uart_data  : out std_logic_vector(7 downto 0);                    -- data
			rs232_0_from_uart_error : out std_logic;                                       -- error
			rs232_0_from_uart_valid : out std_logic;                                       -- valid
			rs232_0_to_uart_data    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- data
			rs232_0_to_uart_error   : in  std_logic                    := 'X';             -- error
			rs232_0_to_uart_valid   : in  std_logic                    := 'X';             -- valid
			rs232_0_to_uart_ready   : out std_logic;                                       -- ready
			clk_clk                 : in  std_logic                    := 'X';             -- clk
			reset_reset_n           : in  std_logic                    := 'X'              -- reset_n
		);
	end component communicator;

	u0 : component communicator
		port map (
			rs232_0_UART_RXD        => CONNECTED_TO_rs232_0_UART_RXD,        --         rs232_0_external_interface.RXD
			rs232_0_UART_TXD        => CONNECTED_TO_rs232_0_UART_TXD,        --                                   .TXD
			rs232_0_from_uart_ready => CONNECTED_TO_rs232_0_from_uart_ready, -- rs232_0_avalon_data_receive_source.ready
			rs232_0_from_uart_data  => CONNECTED_TO_rs232_0_from_uart_data,  --                                   .data
			rs232_0_from_uart_error => CONNECTED_TO_rs232_0_from_uart_error, --                                   .error
			rs232_0_from_uart_valid => CONNECTED_TO_rs232_0_from_uart_valid, --                                   .valid
			rs232_0_to_uart_data    => CONNECTED_TO_rs232_0_to_uart_data,    --  rs232_0_avalon_data_transmit_sink.data
			rs232_0_to_uart_error   => CONNECTED_TO_rs232_0_to_uart_error,   --                                   .error
			rs232_0_to_uart_valid   => CONNECTED_TO_rs232_0_to_uart_valid,   --                                   .valid
			rs232_0_to_uart_ready   => CONNECTED_TO_rs232_0_to_uart_ready,   --                                   .ready
			clk_clk                 => CONNECTED_TO_clk_clk,                 --                                clk.clk
			reset_reset_n           => CONNECTED_TO_reset_reset_n            --                              reset.reset_n
		);

