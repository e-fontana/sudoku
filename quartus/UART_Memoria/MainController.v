/**
 * @brief Módulo Topo (MainController) que orquestra o fluxo de comunicação do jogo.
 *
 * Ele gerencia uma máquina de estados de alto nível para decidir qual tipo de
 * informação enviar com base no estado do jogo. Ele ativa os sub-módulos
 * responsáveis por cada pacote de dados e arbitra o acesso deles à UART.
 */
module MainController #(
    // Parâmetros de estado do JOGO (entradas)
    parameter INICIAR_JOGO          = 3'b000,
    parameter SELECIONAR_DIFICULDADE = 3'b001,
    parameter CARREGANDO            = 3'b010,
    parameter CORRENDO_MAPA         = 3'b011,
    parameter VITORIA               = 3'b101,
    parameter DERROTA               = 3'b110
) (
    input clock,
    input reset,

    // --- Interface com a Lógica do Jogo ---
    input [2:0]   current_state,
    input         game_dificulty,
    input [323:0] full_board,
    input [161:0] colors,
    input [7:0]   position, // Combinado x,y
    input [1:0]   errors,
    input [3:0]   selected_number,
    input         victory_condition,
    input [6:0]   score,
    input [10:0]  time_in_seconds,

    // --- Interface com a UART ---
    input         uart_busy,
    output        tx_start,
    output [7:0]  tx_data
);

    //================================================================
    // 1. Fios de Conexão Interna (Sub-módulos <-> MainController)
    //================================================================

    // Sinais de habilitação (MainController -> Sub-módulos)
    reg habilitar_envio_start;
    reg habilitar_envio_dificuldade;
    reg habilitar_envio_board;
    reg habilitar_envio_status;
    reg habilitar_envio_endgame;

    // Sinais de conclusão (Sub-módulos -> MainController)
    wire envio_concluido_start;
    wire envio_concluido_dificuldade;
    wire envio_concluido_board;
    wire envio_concluido_status;
    wire envio_concluido_endgame;
    
    // Sinais de dados para a UART (Sub-módulos -> MUX de Arbitragem)
    wire start_tx_start;
    wire [7:0] start_tx_data;
    wire dificuldade_tx_start;
    wire [7:0] dificuldade_tx_data;
    wire board_tx_start;
    wire [7:0] board_tx_data;
    wire status_tx_start;
    wire [7:0] status_tx_data;
    wire endgame_tx_start;
    wire [7:0] endgame_tx_data;

    //================================================================
    // 2. INSTANCIAÇÃO DOS SUB-MÓDULOS
    //================================================================

    // Assumindo que você tem módulos para cada tipo de pacote, similar ao GameStatusSend.
    // Se um módulo for muito simples (1 byte), ele pode ser implementado diretamente na FSM.
    
    StartGameSend startGameSender (
        .clock(clock), .reset(reset),
        .habilitar_envio(habilitar_envio_start), .uart_ocupado(uart_busy),
        // não há dados de entrada para este
        .iniciar_envio(start_tx_start), .dado_saida(start_tx_data), .envio_concluido(envio_concluido_start)
    );
    
    DifficultySend difficultySender (
        .clock(clock), .reset(reset),
        .habilitar_envio(habilitar_envio_dificuldade), .uart_ocupado(uart_busy),
        .game_dificulty(game_dificulty),
        .iniciar_envio(dificuldade_tx_start), .dado_saida(dificuldade_tx_data), .envio_concluido(envio_concluido_dificuldade)
    );

    BoardSend boardSender (
        .clock(clock), .reset(reset),
        .habilitar_envio(habilitar_envio_board), .uart_ocupado(uart_busy),
        .full_board(full_board),
        .iniciar_envio(board_tx_start), .dado_saida(board_tx_data), .envio_concluido(envio_concluido_board)
    );

    // Usando o módulo que aprimoramos como exemplo
    GameStatusSend statusSender (
        .clock(clock), .reset(reset),
        .habilitar_envio(habilitar_envio_status), .uart_ocupado(uart_busy),
        .colors(colors), .position(position), .errors(errors), .selected_number(selected_number),
        .iniciar_envio(status_tx_start), .dado_saida(status_tx_data), .envio_concluido(envio_concluido_status)
    );

    EndGameSend endGameSender (
        .clock(clock), .reset(reset),
        .habilitar_envio(habilitar_envio_endgame), .uart_ocupado(uart_busy),
        .victory_condition(victory_condition), .score(score), .time_in_seconds(time_in_seconds),
        .iniciar_envio(endgame_tx_start), .dado_saida(endgame_tx_data), .envio_concluido(envio_concluido_endgame)
    );


    //================================================================
    // 3. MÁQUINA DE ESTADOS DE ORQUESTRAÇÃO
    //================================================================
    localparam FSM_IDLE              = 4'b0000;
    localparam FSM_SEND_START        = 4'b0001;
    localparam FSM_WAIT_START_DONE   = 4'b0010;
    localparam FSM_SEND_DIFFICULTY   = 4'b0011;
    localparam FSM_WAIT_DIFFICULTY_DONE = 4'b0100;
    localparam FSM_SEND_BOARD        = 4'b0101;
    localparam FSM_WAIT_BOARD_DONE   = 4'b0110;
    localparam FSM_RUNNING_SEND_STATUS = 4'b0111;
    localparam FSM_RUNNING_WAIT_STATUS = 4'b1000;
    localparam FSM_SEND_ENDGAME      = 4'b1001;
    localparam FSM_WAIT_ENDGAME_DONE = 4'b1010;
    localparam FSM_GAMEOVER          = 4'b1011;

    reg [3:0] estado, proximo_estado;

    // Processo Sequencial (Registrador de Estado)
    always @(posedge clock or posedge reset) begin
        if (reset)
            estado <= FSM_IDLE;
        else
            estado <= proximo_estado;
    end

    // Processo Combinacional (Lógica de Próximo Estado)
    always @(*) begin
        proximo_estado = estado; // Padrão: manter estado
        case(estado)
            FSM_IDLE: 
                if (current_state == INICIAR_JOGO) proximo_estado = FSM_SEND_START;

            FSM_SEND_START: 
                proximo_estado = FSM_WAIT_START_DONE;

            FSM_WAIT_START_DONE:
                if (envio_concluido_start) proximo_estado = FSM_SEND_DIFFICULTY;
            
            FSM_SEND_DIFFICULTY:
                 proximo_estado = FSM_WAIT_DIFFICULTY_DONE;

            FSM_WAIT_DIFFICULTY_DONE:
                 if (envio_concluido_dificuldade && (current_state == CARREGANDO || current_state == CORRENDO_MAPA))
                    proximo_estado = FSM_SEND_BOARD;
            
            FSM_SEND_BOARD:
                proximo_estado = FSM_WAIT_BOARD_DONE;

            FSM_WAIT_BOARD_DONE:
                if (envio_concluido_board) proximo_estado = FSM_RUNNING_SEND_STATUS;

            FSM_RUNNING_SEND_STATUS:
                 proximo_estado = FSM_RUNNING_WAIT_STATUS;

            FSM_RUNNING_WAIT_STATUS:
                if (envio_concluido_status) begin
                    if (current_state == VITORIA || current_state == DERROTA)
                        proximo_estado = FSM_SEND_ENDGAME;
                    else
                        proximo_estado = FSM_RUNNING_SEND_STATUS; // Envia próximo status
                end

            FSM_SEND_ENDGAME:
                proximo_estado = FSM_WAIT_ENDGAME_DONE;
            
            FSM_WAIT_ENDGAME_DONE:
                if (envio_concluido_endgame) proximo_estado = FSM_GAMEOVER;

            FSM_GAMEOVER:
                // Fica aqui até o reset
                proximo_estado = FSM_GAMEOVER;
        endcase
    end

    // Processo Combinacional (Lógica de Saída - Habilitação dos sub-módulos)
    always @(*) begin
        // Padrão: nenhum módulo habilitado
        habilitar_envio_start       = 1'b0;
        habilitar_envio_dificuldade = 1'b0;
        habilitar_envio_board       = 1'b0;
        habilitar_envio_status      = 1'b0;
        habilitar_envio_endgame     = 1'b0;
        
        case(estado)
            FSM_SEND_START:            habilitar_envio_start       = 1'b1;
            FSM_SEND_DIFFICULTY:       habilitar_envio_dificuldade = 1'b1;
            FSM_SEND_BOARD:            habilitar_envio_board       = 1'b1;
            FSM_RUNNING_SEND_STATUS:   habilitar_envio_status      = 1'b1;
            FSM_SEND_ENDGAME:          habilitar_envio_endgame     = 1'b1;
        endcase
    end


    //================================================================
    // 4. ARBITRAGEM E MUX DA SAÍDA PARA A UART
    //================================================================
    // Com base no estado da FSM, seleciona qual sub-módulo tem permissão
    // para controlar a interface da UART.
    assign tx_start = 
        (estado == FSM_WAIT_START_DONE)     ? start_tx_start :
        (estado == FSM_WAIT_DIFFICULTY_DONE)? dificuldade_tx_start :
        (estado == FSM_WAIT_BOARD_DONE)     ? board_tx_start :
        (estado == FSM_RUNNING_WAIT_STATUS) ? status_tx_start :
        (estado == FSM_WAIT_ENDGAME_DONE)   ? endgame_tx_start :
        1'b0;

    assign tx_data = 
        (estado == FSM_WAIT_START_DONE)     ? start_tx_data :
        (estado == FSM_WAIT_DIFFICULTY_DONE)? dificuldade_tx_data :
        (estado == FSM_WAIT_BOARD_DONE)     ? board_tx_data :
        (estado == FSM_RUNNING_WAIT_STATUS) ? status_tx_data :
        (estado == FSM_WAIT_ENDGAME_DONE)   ? endgame_tx_data :
        8'h00;

endmodule