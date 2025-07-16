module MainController #(
    parameter INICIAR_JOGO              = 3'b000,
    parameter SELECIONAR_DIFICULDADE    = 3'b001,
    parameter CARREGANDO                = 3'b010,
    parameter CORRENDO_MAPA             = 3'b011,
    parameter PERCORRER_NUMEROS         = 3'b100,
    parameter VITORIA                   = 3'b101,
    parameter DERROTA                   = 3'b110
) (
    input clock,
    input reset,

    input [2:0]   current_state,
    input         game_dificulty,
    input [323:0] full_board,
    input [161:0] colors,
    input [7:0]   position,
    input [1:0]   errors,
    input [3:0]   selected_number,
    input         victory_condition,
    input [6:0]   score,
    input [10:0]  time_in_seconds,
    input         uart_busy,

    output reg        tx_start,
    output reg [7:0]  tx_data
);
    localparam S_IDLE           = 3'b000;
    localparam S_START_GAME     = 3'b001;
    localparam S_SEND_DIFICULTY = 3'b010;
    localparam S_SEND_MAP       = 3'b011;
    localparam S_SEND_STATUS    = 3'b100;
    localparam S_SEND_END_GAME  = 3'b101;

    reg [2:0] arb_state, next_arb_state;
    reg start_game_enable_send, dificulty_enable_send, board_enable_send, status_enable_send, end_game_enable_send;

    wire start_game_tx_start, start_game_data_sent;
    wire dificult_tx_start, dificult_data_sent;
    wire board_data_sent, board_tx_start;
    wire status_data_sent, status_tx_start;
    wire end_game_tx_start, end_game_data_sent;

    wire [7:0] board_tx_data, status_tx_data, start_game_tx_data, dificulty_tx_data, end_game_tx_data;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            arb_state <= S_IDLE;
        end else begin
            arb_state <= next_arb_state;
        end
    end

    always @(*) begin
        next_arb_state = arb_state;
        start_enable_send = 1'b0;
        dificult_enable_send = 1'b0;
        board_enable_send = 1'b0;
        status_enable_send = 1'b0;
        end_game_enable_send = 1'b0;
        tx_start = 1'b0;
        tx_data = 8'b0;

        case (arb_state)
            S_IDLE: begin
                case (current_state)
                    INICIAR_JOGO: begin
                        next_arb_state = S_SEND_START_GAME;
                    end
                    SELECIONAR_DIFICULDADE: begin
                        next_arb_state = S_SEND_DIFICULTY;
                    end
                    CARREGANDO: begin
                        next_arb_state = S_SEND_MAP;
                    end
                    CORRENDO_MAPA, PERCORRER_NUMEROS: begin
                        next_arb_state = S_SEND_STATUS;
                    end
                    VITORIA, DERROTA: begin
                        next_arb_state = S_SEND_END_GAME;
                    end
                    default: begin
                        next_arb_state = S_IDLE;
                    end
                endcase
            end
            S_SEND_START_GAME: begin
                start_enable_send = 1'b1;
                tx_start = start_tx_start;
                tx_data = start_game_tx_data;

                if (start_game_data_sent) next_arb_state = S_IDLE;
            end
            S_SEND_DIFICULTY: begin
                dificulty_enable_send = 1'b1;
                tx_start = dificult_tx_start;
                tx_data = dificult_tx_data;

                if (dificult_data_sent) next_arb_state = S_IDLE;
            end
            S_SEND_MAP: begin
                board_enable_send = 1'b1;
                tx_start = board_tx_start;
                tx_data = board_tx_data;

                if (board_data_sent) next_arb_state = S_IDLE;
            end
            S_SEND_STATUS: begin
                status_enable_send = 1'b1;
                tx_start = status_tx_start;
                tx_data = status_tx_data;

                if (status_data_sent) next_arb_state = S_IDLE;
            end
            S_SEND_END_GAME: begin
                end_game_enable_send = 1'b1;
                tx_start = end_game_tx_start;
                tx_data = end_game_tx_data;

                if (end_game_data_sent) next_arb_state = S_IDLE;
            end
            default: begin
                next_arb_state = S_IDLE;
            end
        endcase
    end

    SendStartGame send_start_game (
        .clock(clock),
        .reset(reset),
        .start(start_enable_send),
        
        .game_started(current_state == INICIAR_JOGO),

        .tx_busy(uart_busy),
        .tx_start(start_game_tx_start),
        .tx_data(start_game_tx_data),
        .data_sent(start_game_data_sent)
    );

    SendGameDificulty send_game_dificulty (
        .clock(clock),
        .reset(reset),
        .start(dificulty_enable_send),
        
        .dificuldade(game_dificulty),

        .tx_busy(uart_busy),
        .tx_start(dificult_tx_start),
        .tx_data(dificulty_tx_data),
        .data_sent(dificult_data_sent)
    );

    SendFullMap map_sender (
        .clock(clock),
        .reset(reset),
        .habilitar_envio(board_enable_send),
        .uart_ocupado(uart_busy),
        .full_map_input(full_board),
        .iniciar_envio(board_tx_start),
        .dado_saida(board_tx_data),
        .envio_concluido(board_data_sent)
    );

    SendGameStatus status_sender (
        .clock(clock),
        .reset(reset),
        .habilitar_envio(status_enable_send),
        .uart_ocupado(uart_busy),
        .colors(colors),
        .position(position),
        .errors(errors),
        .selected_number(selected_number),
        .iniciar_envio(status_tx_start),
        .dado_saida(status_tx_data),
        .envio_concluido(status_data_sent)
    );

    SendEndGame send_eng_game (
        .clock(clock),
        .reset(reset),
    );
endmodule