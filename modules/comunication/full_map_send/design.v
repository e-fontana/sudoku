module SendFullMap #(parameter EVENT_CODE = 8'hAC) (
    input  wire         clock,
    input  wire         reset,
    input  wire         habilitar_envio,    // pulso de ativação externo
    input  wire         uart_ocupado,
    input  wire [323:0] full_map_input,

    output reg          iniciar_envio,
    output reg [7:0]    dado_saida,
    output wire         envio_concluido     // pulso de 1 ciclo ao final
);
    localparam S_PAUSA_PACOTE   = 3'b000;
    localparam S_PREPARA_CHUNK  = 3'b001;
    localparam S_INICIA_ENVIO   = 3'b010;
    localparam S_ESPERA_FIM     = 3'b011;
    localparam S_PROXIMO_CHUNK  = 3'b100;
    localparam QTD_CHUNKS = 42;
    localparam DELAY_PACOTE = 50_000_000;

    reg [327:0] full_map_data = 328'd0;

    reg [2:0]  estado_atual;
    reg [5:0]  indice_chunk;
    reg [25:0] contador_delay;

    // Controle de envio único
    reg habilitacao_reg;
    always @(posedge clock or posedge reset) begin
        if (reset)
            habilitacao_reg <= 0;
        else if (habilitar_envio)
            habilitacao_reg <= 1;
        else if (estado_atual == S_PAUSA_PACOTE && estado_futuro == S_PAUSA_PACOTE)
            habilitacao_reg <= 0;  // Limpa após envio completo
    end

    // Pulso de envio concluído
    reg envio_concluido_reg;
    assign envio_concluido = envio_concluido_reg;

    always @(posedge clock or posedge reset) begin
        if (reset)
            envio_concluido_reg <= 0;
        else if (estado_atual == S_PROXIMO_CHUNK && indice_chunk == QTD_CHUNKS - 1)
            envio_concluido_reg <= 1;
        else
            envio_concluido_reg <= 0;
    end

    // Lógica de máquina de estados
    always @(posedge clock or posedge reset)
    begin
        if (reset)
        begin
            estado_atual   <= S_PAUSA_PACOTE;
            contador_delay <= 0;
            indice_chunk   <= 0;
            iniciar_envio  <= 0;
            dado_saida     <= 8'h00;
        end
        else
        begin
            case (estado_atual)
                S_PAUSA_PACOTE:
                begin
                    iniciar_envio <= 0;

                    if (!habilitacao_reg) begin
                        contador_delay <= 0;
                        indice_chunk   <= 0;
                    end else if (contador_delay >= DELAY_PACOTE - 1) begin
                        estado_atual   <= S_PREPARA_CHUNK;
                        contador_delay <= 0;
                        indice_chunk   <= 0;
                    end else begin
                        contador_delay <= contador_delay + 1;
                    end
                end

                S_PREPARA_CHUNK:
                begin
                    reg [7:0] byte_original;
                    if (indice_chunk == 0) begin
                        dado_saida <= EVENT_CODE;
                    end else begin
                        byte_original = full_map_data >> ((indice_chunk - 1) * 8);
                        dado_saida <= {byte_original[3:0], byte_original[7:4]};
                    end
                    if (!uart_ocupado)
                        estado_atual <= S_INICIA_ENVIO;
                end

                S_INICIA_ENVIO:
                begin
                    iniciar_envio <= 1;
                    estado_atual  <= S_ESPERA_FIM;
                end

                S_ESPERA_FIM:
                begin
                    iniciar_envio <= 0;
                    if (!uart_ocupado)
                        estado_atual <= S_PROXIMO_CHUNK;
                end

                S_PROXIMO_CHUNK:
                begin
                    if (indice_chunk < QTD_CHUNKS - 1) begin
                        indice_chunk <= indice_chunk + 1;
                        estado_atual <= S_PREPARA_CHUNK;
                    end else begin
                        estado_atual <= S_PAUSA_PACOTE;
                    end
                end

                default:
                    estado_atual <= S_PAUSA_PACOTE;
            endcase
        end
    end

    // Estado futuro (para uso no reset de habilitacao_reg)
    reg [2:0] estado_futuro;
    always @(*) begin
        estado_futuro = estado_atual;
        full_map_data = {
            4'h0,
            full_map_input,
        };
        case (estado_atual)
            S_PAUSA_PACOTE:
                if (habilitacao_reg && contador_delay >= DELAY_PACOTE - 1)
                    estado_futuro = S_PREPARA_CHUNK;
                else
                    estado_futuro = S_PAUSA_PACOTE;
            S_PREPARA_CHUNK: if (!uart_ocupado) estado_futuro = S_INICIA_ENVIO;
            S_INICIA_ENVIO:   estado_futuro = S_ESPERA_FIM;
            S_ESPERA_FIM:     if (!uart_ocupado) estado_futuro = S_PROXIMO_CHUNK;
            S_PROXIMO_CHUNK:
                if (indice_chunk < QTD_CHUNKS - 1)
                    estado_futuro = S_PREPARA_CHUNK;
                else
                    estado_futuro = S_PAUSA_PACOTE;
        endcase
    end
endmodule
