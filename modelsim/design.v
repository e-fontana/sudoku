/*******************************************************************************
* M�dulo: NibblePackerSerializer (Vers�o Final de Compatibilidade)
*
* Descri��o:
* Empacota unidades de 4 bits de um vetor grande em bytes de 8 bits e os
* envia sequencialmente para uma interface UART.
*
*******************************************************************************/
module NibblePackerSerializer #(
    parameter DATA_WIDTH  = 324,
    parameter UNIT_WIDTH  = 4,
    parameter CHUNK_WIDTH = 8
) (
    // Sinais de Controle
    input clk,
    input rst,
    input start_transmission,

    // Vetor de Dados de Entrada
    input [DATA_WIDTH-1:0] data_to_send,

    // Interface com a UART (Transmissor)
    output reg [CHUNK_WIDTH-1:0] uart_tx_data,
    output reg                   uart_tx_valid,
    input                        uart_tx_ready,

    // Sinal de Status de Sa�da
    output reg transmission_done
);

    // --- Par�metros Calculados ---
    localparam NUM_UNITS        = DATA_WIDTH / UNIT_WIDTH;
    localparam HAS_REMAINDER    = (NUM_UNITS % 2 != 0);
    localparam NUM_PACKED_BYTES = NUM_UNITS / 2;
    localparam NUM_UART_TX      = NUM_PACKED_BYTES + HAS_REMAINDER;
    localparam TX_COUNTER_WIDTH = (NUM_UART_TX > 0) ? $clog2(NUM_UART_TX) : 1;

    // --- Estados da M�quina de Estados ---
    localparam S_IDLE        = 2'b00, S_SEND_BYTE = 2'b01,
               S_WAIT_READY  = 2'b10, S_DONE      = 2'b11;

    // --- Registradores Internos ---
    reg [1:0]                  state;
    reg [TX_COUNTER_WIDTH-1:0] tx_counter;

    // --- L�gica da M�quina de Estados (sequencial) ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE; tx_counter <= 0; uart_tx_valid <= 0; transmission_done <= 0;
        end else begin
            uart_tx_valid <= 0;
            case (state)
                S_IDLE: if (start_transmission) begin state <= S_SEND_BYTE; tx_counter <= 0; transmission_done <= 0; end
                S_SEND_BYTE: state <= S_WAIT_READY;
                S_WAIT_READY: if (uart_tx_ready) if (tx_counter < NUM_UART_TX - 1) begin tx_counter <= tx_counter + 1; state <= S_SEND_BYTE; end else begin transmission_done <= 1; state <= S_DONE; end
                S_DONE: if (!start_transmission) state <= S_IDLE;
            endcase
        end
    end

    // --- L�gica de Empacotamento e Sele��o (combinacional) ---

    // ============================ IN�CIO DA CORRE��O ============================
    // Vari�veis tempor�rias para o c�lculo dos �ndices, declaradas fora do always.
    integer start_bit_A, start_bit_B;
    // ============================= FIM DA CORRE��O ==============================

    always @(*) begin
        // Valor padr�o para evitar a infer�ncia de latches
        uart_tx_data = 8'b0;
        
        if (HAS_REMAINDER && (tx_counter == NUM_UART_TX - 1)) begin
            uart_tx_data = {data_to_send[UNIT_WIDTH-1:0], {(CHUNK_WIDTH - UNIT_WIDTH){1'b0}}};
        end else if (tx_counter < NUM_PACKED_BYTES) begin
            start_bit_A = DATA_WIDTH - 1 - ( (tx_counter * 2) * UNIT_WIDTH );
            start_bit_B = DATA_WIDTH - 1 - ( (tx_counter * 2 + 1) * UNIT_WIDTH );
            uart_tx_data = {data_to_send[start_bit_A -: UNIT_WIDTH], data_to_send[start_bit_B -: UNIT_WIDTH]};
        end
    end

endmodule