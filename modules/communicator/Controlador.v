module Controlador (
input clock,
input reset,
output reg [4:0] a_rom,
output reg clock_rom,
output reg wren,
output reg [4:0] a_ram,
output reg clock_ram,
output reg signed [5:0] i
);


parameter	Inicio = 4'b0000,
				Config_enderecos = 4'b0001,
				Ler_ROM = 4'b0010,
				Escrever_RAM = 4'b0011,
				Decrementar_i = 4'b0100,
				Config_RAM = 4'b0101,
				Ler_RAM = 4'b0110,
				Incrementar_i = 4'b0111,
				Encerrar = 4'b1000;
				
reg [3:0] estado_atual, estado_futuro;

// reg estado
always @ (posedge clock)
begin
	if (reset)
	begin
		estado_atual <= Inicio;
		i <= 31;
	end
	else
	begin
		estado_atual <= estado_futuro;
		if (estado_futuro == Decrementar_i)
			i <= i - 1;
		if (estado_futuro == Incrementar_i)
			i <= i + 1;
	end
end

// dec proximo estado
always @ (*)
begin
	case (estado_atual)
		Inicio: 				estado_futuro = Config_enderecos;
		Config_enderecos: estado_futuro = Ler_ROM;
		Ler_ROM: 			estado_futuro = Escrever_RAM;
		Escrever_RAM: 		estado_futuro = Decrementar_i;
		Decrementar_i:		if (i < 0)				
									estado_futuro = Incrementar_i; 
								else
									estado_futuro = Config_enderecos;
		Config_RAM:			estado_futuro = Ler_RAM;
		Ler_RAM:				estado_futuro = Incrementar_i;
		Incrementar_i:		if (i<32)
									estado_futuro = Config_RAM;
								else
									estado_futuro = Encerrar;
		Encerrar: 			estado_futuro = Encerrar;
		default: estado_futuro = Inicio;
	endcase
end

// dec saida
always @ (*)
begin
	// atribuições default
	clock_rom = 0;
	clock_ram = 0;
	a_rom= 0;
	a_ram = 31;
	wren = 0;
	case (estado_atual)
		Config_enderecos: begin
									a_rom = i;
									a_ram = 31 - i;
								end
		Ler_ROM:				begin
									a_rom = i;
									a_ram = 31 - i;
									clock_rom = 1;
									wren = 1;
								end
		Escrever_RAM:		begin
									a_ram = 31 - i;
									wren = 1;
									clock_ram = 1;
								end
		Config_RAM:			a_ram = i;
		Ler_RAM:				begin
									a_ram = i;
									clock_ram = 1;
								end
	endcase
end

endmodule 