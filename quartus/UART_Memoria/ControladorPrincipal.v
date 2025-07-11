module ControladorPrincipal (
	input clock,
	input reset,
	input tx_busy,
	input send_data,
	output reg [3:0] a_ram,
	output reg clock_ram,
	output reg tx_start,
	output reg [7:0] tx_data
);

parameter	Inicio = 					3'b000, // use este estado para aguardar a solicitacao de envio para o PC
				Config_Enderecos = 		3'b001,
				Ler_RAM = 					3'b010,
				Transmitir_UART = 		3'b011,
				Incrementar_i = 			3'b100,
				Aguardar_TX = 				3'b101,
				Aguardar_Tempo =        3'b110;
				
reg [2:0] estado_atual, estado_futuro;

integer i, ContadorTempo;

reg FlagTemporizador;

// reg estado
always @ (posedge clock)
begin
	if (reset)
	begin
		estado_atual <= Inicio;
		i <= 0;
		ContadorTempo <= 0;
		FlagTemporizador <= 0;
	end
	else
	begin
		estado_atual <= estado_futuro;
		if (estado_futuro == Incrementar_i)
		begin
			if (i == 10) // limitado a 11 palavras de memoria, reiniciando para a posicao inicial
			begin
				i <= 0;
				FlagTemporizador <= 1;
			end
			else
			begin
				i <= i + 1;
			end
		end
		if (estado_futuro == Aguardar_Tempo)
		begin
			ContadorTempo <= ContadorTempo + 1;
			FlagTemporizador <= 0; 
		end
		else
		begin
			ContadorTempo <= 0;
		end
	end
end


// dec proximo estado
always @ (*)
begin
	case (estado_atual)
		Inicio: 					estado_futuro = Config_Enderecos;
		Config_Enderecos: 	estado_futuro = Ler_RAM;
		Ler_RAM: 				estado_futuro = Transmitir_UART;
		Transmitir_UART: 		estado_futuro = Incrementar_i;
		Incrementar_i:			estado_futuro = Aguardar_TX;
		Aguardar_TX:			if (tx_busy)
										begin
											estado_futuro = Aguardar_TX;
										end
									else
										if (FlagTemporizador)
											begin
												estado_futuro = Aguardar_Tempo;
											end
										else
											begin
												estado_futuro = Config_Enderecos;
											end
		Aguardar_Tempo:		if (ContadorTempo < 5000000)			// Aguarda 1 segundo (adaptem para suas necessidades)
									begin
										estado_futuro = Aguardar_Tempo;
									end
									else
									begin
										estado_futuro = Config_Enderecos; 
									end
		default: estado_futuro = Inicio;
	endcase
end


// dec saida
always @ (*)
begin
	// atribuicoes default
	clock_ram = 0;
	tx_start = 0;
	tx_data <= 8'h00;
	case (estado_atual)
		Config_Enderecos: begin
									a_ram = i;
								end
		Ler_RAM:				begin
									a_ram = i;
									clock_ram = 1;
								end
		Transmitir_UART:	begin
									tx_data <= 8'hAA;
									a_ram = i;
									tx_start = 1;
								end
	endcase
end

endmodule
