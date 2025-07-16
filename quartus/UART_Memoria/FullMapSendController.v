module FullMapSendController #(
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

    localparam MAP_SIZE_BYTES = 42;
    localparam MAP_SIZE_BITS  = MAP_SIZE_BYTES * 8;

    wire [327:0] payload_data = { 4'h00, full_map_input };

		PayloadController #(
			.EVENT_CODE(EVENT_CODE),
			.SEND_BYTES_QTD(23),
			.MSB_FIRST(0)
		) payload_controller  (
			.clock(clock),
			.reset(reset),
			.habilitar_envio(habilitar_envio),    // pulso de ativação externo
			.uart_ocupado(uart_ocupado),

			.buffer_envio(payload_data),

			.iniciar_envio(iniciar_envio),
			.dado_saida(dado_saida),
			.envio_concluido(envio_concluido)     // pulso de 1 ciclo ao final
		);

endmodule
