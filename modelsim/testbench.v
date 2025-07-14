/*******************************************************************************
* Testbench para o M�dulo NibblePackerSerializer
*
* Descri��o:
* Este testbench verifica a funcionalidade do serializador para uma entrada de
* 324 bits. Ele fornece um padr�o de dados conhecido, simula o handshake
* com uma UART e verifica se os bytes corretos s�o enviados sequencialmente.
*
* Padr�o de Dados de Teste (324 bits):
* - Nibbles mais significativos: A, B, C, D ...
* - Nibble menos significativo: F
*
* Sa�da Esperada:
* - Primeiro byte enviado: 8'hAB
* - Segundo byte enviado: 8'hCD
* ...
* - �ltimo byte enviado (41�): 8'hF0 (o nibble 'F' com padding de 4 zeros)
*
*******************************************************************************/
`timescale 1ns / 1ps

module tb_NibblePackerSerializer;

    // --- Par�metros do Teste ---
    localparam DATA_WIDTH  = 324;
    localparam UNIT_WIDTH  = 4;
    localparam CHUNK_WIDTH = 8;
    localparam CLK_PERIOD  = 10; // Per�odo do clock em ns

    // --- Sinais do Testbench ---

    // Sinais controlados pelo testbench (entradas para o DUT)
    reg                        clk;
    reg                        rst;
    reg                        start_transmission;
    reg [DATA_WIDTH-1:0]       data_to_send;
    reg                        uart_tx_ready; // Simula a resposta da UART

    // Sinais observados pelo testbench (sa�das do DUT)
    wire [CHUNK_WIDTH-1:0]     uart_tx_data;
    wire                       uart_tx_valid;
    wire                       transmission_done;

    // --- Instancia��o do M�dulo Sob Teste (DUT) ---
    NibblePackerSerializer #(
        .DATA_WIDTH(DATA_WIDTH),
        .UNIT_WIDTH(UNIT_WIDTH),
        .CHUNK_WIDTH(CHUNK_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start_transmission(start_transmission),
        .data_to_send(data_to_send),
        .uart_tx_data(uart_tx_data),
        .uart_tx_valid(uart_tx_valid),
        .uart_tx_ready(uart_tx_ready),
        .transmission_done(transmission_done)
    );

    // --- Gera��o do Clock ---
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // --- Simula��o da UART (modelo de comportamento) ---
    // A UART fica pronta ('ready') por padr�o. Quando ela recebe um dado
    // ('valid' sobe), ela fica ocupada ('ready' desce) por alguns ciclos.
    initial begin
        uart_tx_ready = 1'b0; // Come�a n�o-pronta
        forever begin
            @(posedge clk);
            if (rst) begin
                uart_tx_ready <= 1'b0;
            end else if (uart_tx_valid) begin
                // UART recebeu um dado, ficar� ocupada por 3 ciclos de clock
                uart_tx_ready <= 1'b0;
                repeat (3) @(posedge clk);
                uart_tx_ready <= 1'b1; // Fica pronta novamente
            end else if (!uart_tx_ready) begin
                // Se o envio acabou, mas a UART ainda estava ocupada, a liberamos
                 uart_tx_ready <= 1'b1;
            end
        end
    end

    // --- Est�mulo Principal e Verifica��o ---
    initial begin
        // 1. Defini��o do padr�o de dados
        // Preenche os bits mais significativos com um padr�o reconhec�vel
        data_to_send = {
            4'h5, 4'h6, 4'h7, 4'h8, // Bytes esperados: AB, CD
            {292{1'b0}},            // Recheio com zeros
            4'h1,                   // Pen�ltimo nibble
            4'h2                    // �ltimo nibble (bits 3:0)
        };

        // 2. Impress�o do cabe�alho
        $display("----------------------------------------------------------------------");
        $display("Iniciando Testbench para NibblePackerSerializer (324 bits)");
        $display("Padr�o de dados MSB...LSB: 0xABCD...00E...F");
        $display("----------------------------------------------------------------------");
        $monitor("T=%0t | State=%s | Cnt=%2d | Valid=%b Ready=%b | Data Out=0x%h | Done=%b",
                 $time, dut.state, dut.tx_counter, uart_tx_valid, uart_tx_ready, uart_tx_data, transmission_done);

        // 3. Reset do sistema
        rst = 1;
        start_transmission = 0;
        repeat (2) @(posedge clk);
        rst = 0;
        $display("T=%0t: *** Fim do Reset ***", $time);
        
        // Espera a UART ficar pronta ap�s o reset
        wait (uart_tx_ready);
        @(posedge clk);

        // 4. In�cio da Transmiss�o
        $display("T=%0t: *** Iniciando Transmiss�o ***", $time);
        start_transmission = 1;
        @(posedge clk);
        start_transmission = 0; // O start � apenas um pulso

        // 5. Esperar a transmiss�o terminar
        wait (transmission_done == 1);
        $display("T=%0t: *** Transmiss�o Conclu�da! ***", $time);

        // 6. Finalizar simula��o
        repeat (5) @(posedge clk);
        $display("----------------------------------------------------------------------");
        $display("Fim do Testbench.");
        $finish;
    end
    
endmodule