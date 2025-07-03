`timescale 1ns / 1ps

module controller_reader_tb;

    // Sinais de entrada
    reg clock = 0;
    reg reset = 1;
    reg PIN_UP_Z;
    reg PIN_DOWN_Y;
    reg PIN_LEFT_X;
    reg PIN_RIGHT_MODE;
    reg PIN_A_B;
    reg PIN_START_C;
    reg flag = 0;

    // Sinais de saida
    wire select;
    wire [11:0] LEDR;
    wire [11:0] controller_output;
    wire [11:0] controller_reader_output;

    controller cntrl (
	.clk(clock),
	.reset(reset),
 	.block_controller(flag),
    	
	.controller_input(controller_reader_output),
    	.LEDR(LEDR),
        .controller_output(controller_output)
    );

    // Instancia do modulo sendo testado
    controller_reader uut (
        .clk(clock),
        .reset(reset),
        .PIN_UP_Z(PIN_UP_Z),
        .PIN_DOWN_Y(PIN_DOWN_Y),
        .PIN_LEFT_X(PIN_LEFT_X),
        .PIN_RIGHT_MODE(PIN_RIGHT_MODE),
        .PIN_A_B(PIN_A_B),
        .PIN_START_C(PIN_START_C),
        .select(select),
	    .block(flag),
        .LEDR(controller_reader_output)
    );

    // Geracao do clock (20ns periodo => 50MHz)
    always #10 clock = ~clock;

    initial begin
        $display("Iniciando simula??o...");
        $monitor("Tempo: %dns | LEDR: %b | select: %b", $time, LEDR, select);

        // Inicializacao
        clock = 0;
        reset = 0;

        // Todos os botoes em estado nao pressionado (ativo baixo)
        PIN_UP_Z = 1;
        PIN_DOWN_Y = 1;
        PIN_LEFT_X = 1;
        PIN_RIGHT_MODE = 1;
        PIN_A_B = 1;
        PIN_START_C = 1;

        // Libera o reset apos alguns ciclos
        #500 reset = 1;

        // Aguarda alguns ciclos para o DUT iniciar
        #20000;

        // Simulacao de sequencia de botoes pressionados
        // Pressiona e solta cada botao com tempo suficiente entre os ciclos

	    PIN_UP_Z = 0;     #1000000;  PIN_UP_Z = 1;       // UP
        PIN_DOWN_Y = 0;   #1000000;  PIN_DOWN_Y = 1;     // DOWN
        PIN_LEFT_X = 0;   #1000000;  PIN_LEFT_X = 1;     // LEFT
        PIN_RIGHT_MODE = 0; #1000000; PIN_RIGHT_MODE = 1; // MODE
        PIN_A_B = 0;      #1000000;  PIN_A_B = 1;        // A/B
        PIN_START_C = 0;  #1000000;  PIN_START_C = 1;    // START/C

        // Aguarda o tempo suficiente para passar por todos os estados (~8000 ciclos)
        #2000000;

        $display("Finalizando simulacao...");
        $stop;
    end

endmodule

