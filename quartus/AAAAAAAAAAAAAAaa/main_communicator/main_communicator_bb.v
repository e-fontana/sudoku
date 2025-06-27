
module main_communicator (
	rs232_0_UART_RXD,
	rs232_0_UART_TXD,
	rs232_0_reset,
	rs232_0_from_uart_ready,
	rs232_0_from_uart_data,
	rs232_0_from_uart_error,
	rs232_0_from_uart_valid,
	rs232_0_to_uart_data,
	rs232_0_to_uart_error,
	rs232_0_to_uart_valid,
	rs232_0_to_uart_ready,
	clock_bridge_0_in_clk_clk);	

	input		rs232_0_UART_RXD;
	output		rs232_0_UART_TXD;
	input		rs232_0_reset;
	input		rs232_0_from_uart_ready;
	output	[7:0]	rs232_0_from_uart_data;
	output		rs232_0_from_uart_error;
	output		rs232_0_from_uart_valid;
	input	[7:0]	rs232_0_to_uart_data;
	input		rs232_0_to_uart_error;
	input		rs232_0_to_uart_valid;
	output		rs232_0_to_uart_ready;
	input		clock_bridge_0_in_clk_clk;
endmodule
