module SendFullMap #(
    parameter [7:0] EVENT_CODE = 8'hAC
)(
    input  wire         clock,
    input  wire         reset,
    input  wire         habilitar_envio,
    input  wire         uart_ocupado,
    input  wire [323:0] full_map_input, // 324 bits (40.5 bytes)

    output wire         iniciar_envio,
    output wire [7:0]   dado_saida,
    output wire         envio_concluido
);

    wire [327:0] payload_data = { 4'h00, full_map_input };

	PayloadController #(
		.EVENT_CODE(8'hAC),
		.SEND_BYTES_QTD(41),
		.MSB_FIRST(1)
	) payload_controller  (
		.clock(clock),
		.reset(reset),
		.habilitar_envio(habilitar_envio),
		.uart_ocupado(uart_ocupado),

		.buffer_envio(payload_data),

		.iniciar_envio(iniciar_envio),
		.dado_saida(dado_saida),
		.envio_concluido(envio_concluido)
	);

endmodule
