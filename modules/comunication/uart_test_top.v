`timescale 1ns/1ps

module uart_tx8_tb;
    reg clk;
    reg rst;
    reg start;
    reg [7:0] data;
    wire tx;
    wire busy;

    // Clock 50 MHz
    initial clk = 0;
    always #10 clk = ~clk;

    // Instância do transmissor UART de 8 bits
    uart_tx8 dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data(data),
        .tx(tx),
        .busy(busy)
    );

    initial begin
        // Inicialização
        rst = 1;
        start = 0;
        data = 8'h00;

        #100;           // Aguarda alguns ciclos com reset alto
        rst = 0;        // Libera reset

        #100;           // Espera um pouco antes de iniciar

        data = 8'hAB;   // Dado a ser enviado
        start = 1;      // Envia pulso de start
        #20 start = 0;  // Pulso de 1 ciclo

        // Aguarda até a transmissão terminar
        wait (!busy);

        data = 8'hCD;   // Novo dado a ser enviado
        start = 1;      // Envia pulso de start novamente
        #20 start = 0;  // Pulso de 1 ciclo

        // Aguarda até a transmissão terminar
        wait (!busy);

        #100 $finish;
    end

endmodule
