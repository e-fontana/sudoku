`timescale 1ns / 1ps

module controller_reader_tb;

    // Sinais de entrada
    reg clk = 0;
    reg reset;
    reg PIN_UP_Z;
    reg PIN_DOWN_Y;
    reg PIN_LEFT_X;
    reg PIN_RIGHT_MODE;
    reg PIN_A_B;
    reg PIN_START_C;

    // Sinais de saída
    wire select;
    wire [11:0] LEDR;

    // Instância do módulo sendo testado
    controller_reader uut (
        .clk(clk),
        .reset(reset),
        .PIN_UP_Z(PIN_UP_Z),
        .PIN_DOWN_Y(PIN_DOWN_Y),
        .PIN_LEFT_X(PIN_LEFT_X),
        .PIN_RIGHT_MODE(PIN_RIGHT_MODE),
        .PIN_A_B(PIN_A_B),
        .PIN_START_C(PIN_START_C),
        .select(select),
        .LEDR(LEDR)
    );

    // Geração do clock (20ns período => 50MHz)
    always #10 clk = ~clk;

    initial begin
        $display("Iniciando simulação...");
        $monitor("Tempo: %dns | LEDR: %b | select: %b", $time, LEDR, select);

        // Inicialização
        clk = 0;
        reset = 0;

        // Todos os botões em estado não pressionado (ativo baixo)
        PIN_UP_Z = 1;
        PIN_DOWN_Y = 1;
        PIN_LEFT_X = 1;
        PIN_RIGHT_MODE = 1;
        PIN_A_B = 1;
        PIN_START_C = 1;

        // Libera o reset após alguns ciclos
        #25 reset = 1;

        // Aguarda alguns ciclos para o DUT iniciar
        #1000;

        // Simulação de sequência de botões pressionados
        // Pressiona e solta cada botão com tempo suficiente entre os ciclos

        PIN_UP_Z = 0;     #200;  PIN_UP_Z = 1;       // UP
        PIN_DOWN_Y = 0;   #200;  PIN_DOWN_Y = 1;     // DOWN
        PIN_LEFT_X = 0;   #200;  PIN_LEFT_X = 1;     // LEFT
        PIN_RIGHT_MODE = 0; #200; PIN_RIGHT_MODE = 1; // MODE
        PIN_A_B = 0;      #200;  PIN_A_B = 1;        // A/B
        PIN_START_C = 0;  #200;  PIN_START_C = 1;    // START/C

        // Aguarda o tempo suficiente para passar por todos os estados (~8000 ciclos)
        #100000;

        $display("Finalizando simulação...");
        $stop;
    end

endmodule
