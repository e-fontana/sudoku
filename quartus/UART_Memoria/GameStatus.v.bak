module StatusGameSendController (
    input  wire         clock,
    input  wire         reset,
    input  wire         habilitar_envio,  // pulso para iniciar o envio
    input  wire         uart_ocupado,

    input  wire [80:0]  visibilidade,
    input  wire [161:0] cores,
    input  wire [7:0]   posicao,
    input  wire [1:0]   erros,
    input  wire [3:0]   num_selecionado,

    output reg          iniciar_envio,
    output reg [7:0]    dado_saida,
    output reg          envio_concluido
);

    // Total de bytes a enviar
    localparam TOTAL_BYTES = 40;

    // FSM estados com localparam
    localparam IDLE          = 3'b000;
    localparam PREPARA_ENVIO = 3'b001;
    localparam INICIA_ENVIO  = 3'b010;
    localparam ESPERA_UART   = 3'b011;
    localparam PROXIMO_BYTE  = 3'b100;

    reg [8*TOTAL_BYTES-1:0] buffer_envio;

    reg [2:0] estado_atual, estado_futuro;
    reg [5:0] indice_byte; // índice do byte atual enviado (0 a 39)
    reg habilitacao_reg;    // trava pra só enviar 1 vez

    always @(posedge clock or posedge reset) begin
        if (reset)
            habilitacao_reg <= 1'b0;
        else if (habilitar_envio)
            habilitacao_reg <= 1'b1;
        else if (estado_atual == IDLE)
            habilitacao_reg <= 1'b0;
    end

    always @(posedge clock) begin
        if (estado_futuro == PREPARA_ENVIO) begin
            buffer_envio <= {
                {4'b0000, num_selecionado},  
                8'h46,                       '
                {6'b000000, erros},          
                8'h46,                       
                posicao,                     
                8'h46,                       
                {cores, 6'b000000},          
                8'h46,                       
                {visibilidade, 7'b0000000},
                8'hAD                       
            };
        end
    end

    // FSM combinacional
    always @(*) begin
        estado_futuro = estado_atual;
        iniciar_envio = 1'b0;
        dado_saida = 8'h00;
        envio_concluido = 1'b0;

        case (estado_atual)
            IDLE: begin
                if (habilitacao_reg)
                    estado_futuro = PREPARA_ENVIO;
            end

            PREPARA_ENVIO: begin
                estado_futuro = INICIA_ENVIO;
                // indice_byte inicializado no sequencial
            end

            INICIA_ENVIO: begin
                dado_saida = buffer_envio[8*(TOTAL_BYTES - 1 - indice_byte) +: 8];
                iniciar_envio = 1'b1;
                estado_futuro = ESPERA_UART;
            end

            ESPERA_UART: begin
                iniciar_envio = 1'b0;
                dado_saida = buffer_envio[8*(TOTAL_BYTES - 1 - indice_byte) +: 8];
                if (!uart_ocupado)
                    estado_futuro = PROXIMO_BYTE;
            end

            PROXIMO_BYTE: begin
                if (indice_byte == TOTAL_BYTES - 1) begin
                    envio_concluido = 1'b1;
                    estado_futuro = IDLE;
                end else begin
                    estado_futuro = INICIA_ENVIO;
                end
            end

            default: estado_futuro = IDLE;
        endcase
    end

    // FSM sequencial
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            estado_atual <= IDLE;
            indice_byte <= 0;
            iniciar_envio <= 0;
            dado_saida <= 8'h00;
            envio_concluido <= 0;
        end else begin
            estado_atual <= estado_futuro;

            if (estado_atual == PREPARA_ENVIO) begin
                indice_byte <= 0;
            end else if (estado_atual == PROXIMO_BYTE && estado_futuro == INICIA_ENVIO) begin
                indice_byte <= indice_byte + 1;
            end

            if (estado_atual == INICIA_ENVIO) begin
                iniciar_envio <= 1'b1;
                dado_saida <= buffer_envio[8*(TOTAL_BYTES - 1 - indice_byte) +: 8];
            end else begin
                iniciar_envio <= 1'b0;
            end

            // Envio concluído dura 1 ciclo no IDLE após terminar
            if (estado_atual == PROXIMO_BYTE && estado_futuro == IDLE) begin
                envio_concluido <= 1'b1;
            end else begin
                envio_concluido <= 0;
            end
        end
    end

endmodule
