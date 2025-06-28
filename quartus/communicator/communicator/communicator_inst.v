	communicator u0 (
		.rs232_0_UART_RXD        (<connected-to-rs232_0_UART_RXD>),        //         rs232_0_external_interface.RXD
		.rs232_0_UART_TXD        (<connected-to-rs232_0_UART_TXD>),        //                                   .TXD
		.rs232_0_from_uart_ready (<connected-to-rs232_0_from_uart_ready>), // rs232_0_avalon_data_receive_source.ready
		.rs232_0_from_uart_data  (<connected-to-rs232_0_from_uart_data>),  //                                   .data
		.rs232_0_from_uart_error (<connected-to-rs232_0_from_uart_error>), //                                   .error
		.rs232_0_from_uart_valid (<connected-to-rs232_0_from_uart_valid>), //                                   .valid
		.rs232_0_to_uart_data    (<connected-to-rs232_0_to_uart_data>),    //  rs232_0_avalon_data_transmit_sink.data
		.rs232_0_to_uart_error   (<connected-to-rs232_0_to_uart_error>),   //                                   .error
		.rs232_0_to_uart_valid   (<connected-to-rs232_0_to_uart_valid>),   //                                   .valid
		.rs232_0_to_uart_ready   (<connected-to-rs232_0_to_uart_ready>),   //                                   .ready
		.clk_clk                 (<connected-to-clk_clk>),                 //                                clk.clk
		.reset_reset_n           (<connected-to-reset_reset_n>)            //                              reset.reset_n
	);

