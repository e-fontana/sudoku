	module SendGameStatus #(parameter EVENT_CODE = 8'hAD) (
		 input  wire         clock,
		 input  wire         reset,
		 input  wire         habilitar_envio,    // pulso de ativação externo
		 input  wire         uart_ocupado,

		 input wire [161:0] colors,
		 input wire [7:0] position,         // 8 bits: Posição (x, y)
		 input wire [1:0] errors,
		 input wire [3:0] selected_number,  // 4 bits: Número selecionado;

		 output 				iniciar_envio,
		 output [7:0]    dado_saida,
		 output         envio_concluido     // pulso de 1 ciclo ao final
	);
		wire [327:0] buffer_envio = {
							  colors,         // 162 bits: Dados das cores
							  position,       // 8 bits: Posição (x, y)
							  errors,         // 2 bits: Quantidade de erros
							  selected_number,    // 4 bits: Número selecionado
							  8'b00000000            // 8 bits: Padding para fechar 200 bits
						 };

		PayloadController #(
			.EVENT_CODE(8'hAD),
			.SEND_BYTES_QTD(23)
		) payload_controller  (
			.clock(clock),
			.reset(reset),
			.habilitar_envio(habilitar_envio),    // pulso de ativação externo
			.uart_ocupado(uart_ocupado),

			.buffer_envio(buffer_envio),

			.iniciar_envio(iniciar_envio),
			.dado_saida(dado_saida),
			.envio_concluido(envio_concluido)     // pulso de 1 ciclo ao final
		);
		 
	endmodule