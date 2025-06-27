	unsaved u0 (
		.clk_clk                        (<connected-to-clk_clk>),                        //                        clk.clk
		.reset_reset_n                  (<connected-to-reset_reset_n>),                  //                      reset.reset_n
		.uart_0_reset_reset_n           (<connected-to-uart_0_reset_reset_n>),           //               uart_0_reset.reset_n
		.uart_0_s1_address              (<connected-to-uart_0_s1_address>),              //                  uart_0_s1.address
		.uart_0_s1_begintransfer        (<connected-to-uart_0_s1_begintransfer>),        //                           .begintransfer
		.uart_0_s1_chipselect           (<connected-to-uart_0_s1_chipselect>),           //                           .chipselect
		.uart_0_s1_read_n               (<connected-to-uart_0_s1_read_n>),               //                           .read_n
		.uart_0_s1_write_n              (<connected-to-uart_0_s1_write_n>),              //                           .write_n
		.uart_0_s1_writedata            (<connected-to-uart_0_s1_writedata>),            //                           .writedata
		.uart_0_s1_readdata             (<connected-to-uart_0_s1_readdata>),             //                           .readdata
		.uart_0_irq_irq                 (<connected-to-uart_0_irq_irq>),                 //                 uart_0_irq.irq
		.uart_0_external_connection_rxd (<connected-to-uart_0_external_connection_rxd>), // uart_0_external_connection.rxd
		.uart_0_external_connection_txd (<connected-to-uart_0_external_connection_txd>)  //                           .txd
	);

