/**
 * @file ControladorUART.v
 * @brief Módulo de controle para iniciar uma transmissão UART.
 * @details Este módulo age como uma interface para um transmissor UART.
 * Ele aguarda um pulso em 'start_transmission', captura o dado em 'data_in'
 * e gera os sinais 'tx_start' e 'tx_data' para o módulo UART.
 * Depois, aguarda o fim da transmissão monitorando 'tx_busy'.
 */
module ControladorUART (
    // --- Entradas do Sistema ---
    input  wire        clock,
    input  wire        reset,

    // --- Interface com o Módulo UART ---
    input  wire        tx_busy,          // Sinal da UART indicando que está ocupada

    // --- Interface de Controle e Dados ---
    input  wire        start_transmission, // Sinal para iniciar a transmissão
    input  wire [7:0]  data_in,          // Dado de 8 bits a ser transmitido

    // --- Saídas para o Módulo UART ---
    output reg         tx_start,         // Pulso para iniciar a transmissão na UART
    output reg [7:0]   tx_data           // Dado a ser enviado para a UART
);

    // --- Definição dos Estados da Máquina de Estados ---
    parameter OCIOSO   = 2'b00; // Estado inicial, aguardando comando para transmitir
    parameter TRANSMITIR = 2'b01; // Estado para carregar o dado e iniciar a UART
    parameter AGUARDAR = 2'b10; // Estado para esperar a UART terminar a transmissão

    // --- Registradores da Máquina de Estados ---
    reg [1:0] estado_atual;
    reg [1:0] proximo_estado;

    // --- Registrador para armazenar o dado de entrada ---
    // É importante para garantir que o dado não mude no meio da transmissão
    reg [7:0] data_reg;


    //==================================================================
    // Lógica Sequencial: Atualização de Estados e Registradores
    //==================================================================
    always @(posedge clock or posedge reset)
    begin
        if (reset)
        begin
            estado_atual <= OCIOSO;
            data_reg     <= 8'h00;
        end
        else
        begin
            estado_atual <= proximo_estado;
            // Captura o dado de entrada quando a transmissão é iniciada
            if (proximo_estado == TRANSMITIR)
            begin
                data_reg <= data_in;
            end
        end
    end


    //==================================================================
    // Lógica Combinacional: Decodificador de Próximo Estado
    //==================================================================
    always @(*)
    begin
        case (estado_atual)
            OCIOSO:
            begin
                // Se o sinal de início for recebido, avança para o estado de transmissão
                if (start_transmission)
                    proximo_estado = TRANSMITIR;
                else
                    proximo_estado = OCIOSO;
            end

            TRANSMITIR:
            begin
                // Após o estado de transmissão, sempre vai para o estado de espera
                proximo_estado = AGUARDAR;
            end

            AGUARDAR:
            begin
                // Se a UART ainda estiver ocupada, continua esperando
                if (tx_busy)
                    proximo_estado = AGUARDAR;
                // Se a UART ficou livre, volta ao estado ocioso para a próxima transmissão
                else
                    proximo_estado = OCIOSO;
            end

            default:
                proximo_estado = OCIOSO;
        endcase
    end


    //==================================================================
    // Lógica Combinacional: Lógica de Saída
    //==================================================================
    always @(*)
    begin
        // --- Atribuições Padrão ---
        tx_start = 1'b0;
        tx_data  = data_reg; // A saída de dados sempre reflete o dado capturado

        // --- Lógica de Saída baseada no Estado Atual ---
        case (estado_atual)
            TRANSMITIR:
            begin
                // Gera um pulso de um ciclo de clock em tx_start para iniciar a UART
                tx_start = 1'b1;
            end
        endcase
    end

endmodule