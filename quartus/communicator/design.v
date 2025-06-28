/**
 * @module    uart_avalon_st_tester
 * @brief     Driver de teste para uma UART com interface Avalon Streaming (ST).
 * @author    Gemini AI
 * @date      2025-06-27
 *
 * @description
 * Este módulo se conecta a um IP de UART (RS-232) que usa interfaces Avalon-ST.
 *
 * 1. Lógica de Transmissão: Envia periodicamente um caractere predefinido ('A').
 * Ele implementa o handshake Avalon-ST: espera a UART estar pronta (i_tx_ready=1),
 * então apresenta os dados (o_tx_data) e os valida (o_tx_valid=1).
 *
 * 2. Lógica de Recepção: Está sempre pronta para receber dados (o_rx_ready=1).
 * Isso é crucial para "esvaziar" o buffer de recepção da UART e evitar que
 * ela pare de processar dados caso algo seja recebido pelo pino RXD.
 */
module uart_avalon_st_tester (
    // --- Sinais Globais ---
    input wire clk,
    input wire reset_n,

    // --- Conexão para a Interface de Transmissão da UART (Transmit Sink) ---
    output reg [7:0] o_tx_data,     // Dados que enviaremos para a UART
    output reg       o_tx_valid,    // Sinal que diz "meus dados são válidos"
    input  wire      i_tx_ready,    // Sinal da UART que diz "estou pronto para receber"

    // --- Conexão para a Interface de Recepção da UART (Receive Source) ---
    input  wire [7:0] i_rx_data,     // Dados que a UART recebeu
    input  wire       i_rx_valid,    // Sinal da UART que diz "tenho dados válidos para você"
    output wire       o_rx_ready     // Sinal que diz para a UART "estou pronto para receber"
);

    // --- Parâmetros ---
    // Caractere a ser enviado (ASCII 'A')
    localparam CHAR_TO_SEND = 8'h41;

    // Contador de delay para definir a frequência de envio.
    // Ajuste este valor com base na frequência do seu clock.
    // Ex: Para um clock de 50 MHz, 5,000,000 de ciclos dão um delay de 100ms.
    localparam DELAY_CYCLES = 25'd5_000_000;

    // --- Registos Internos ---
    reg [24:0] delay_counter;

    // --- Lógica de Transmissão ---

    // A transferência de dados (handshake) acontece quando ambos valid e ready estão em '1'.
    wire tx_handshake = o_tx_valid && i_tx_ready;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Estado de reset
            o_tx_valid    <= 1'b0;
            o_tx_data     <= 0;
            delay_counter <= DELAY_CYCLES;
        end else begin
            // Lógica do contador de delay
            if (delay_counter == 0) begin
                delay_counter <= DELAY_CYCLES; // Reinicia o contador
            end else begin
                delay_counter <= delay_counter - 1; // Decrementa
            end

            // Lógica de controle do sinal 'valid'
            // Quando o contador está prestes a zerar, tentamos iniciar um envio.
            if (delay_counter == 1) begin
                o_tx_valid <= 1'b1;
                o_tx_data  <= CHAR_TO_SEND;
            // Se a transferência foi bem-sucedida, desativamos o 'valid'.
            end else if (tx_handshake) begin
                o_tx_valid <= 1'b0;
            end
        end
    end

    // --- Lógica de Recepção ---

    // Estamos sempre prontos para receber dados para não bloquear a UART.
    // Qualquer dado recebido será consumido e descartado.
    assign o_rx_ready = 1'b1;

endmodule