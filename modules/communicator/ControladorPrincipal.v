module ControladorUART (
    input  wire        clock,
    input  wire        reset,
    input  wire        tx_busy,
    input  wire        start_transmission,
    input  wire [7:0]  data_in,

    output reg         tx_start,
    output reg [7:0]   tx_data
);
    parameter OCIOSO   = 2'b00;
    parameter TRANSMITIR = 2'b01;
    parameter AGUARDAR = 2'b10;

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