module game_state_machine (
    // time
    input clk, reset,
    input [10:0] timer,
    
    // buttons
    input up_button, down_button, left_button, right_button, start_button, a_button, b_button,
    // map
    input [80:0] selected_visibility,
    input [323:0] selected_map,
    output error,

    // outputs
    output difficulty,
    output playing_condition,

    output [3:0] n3, n4, n5, n6, n7
);
    reg [2:0] current_state, next_state;

    wire [80:0] visibilities;
    wire [323:0] board;
    wire [3:0] pos_i, pos_j, cell_value, selected_number;
    wire [6:0] index, score;
    wire [1:0] strikes;
    wire cell_visibility_value;

    wire victory_condition, defeat_condition;
    
    parameter [2:0] 
        INICIAR_JOGO        		 = 3'b000,
        SELECIONAR_DIFICULDADE 	     = 3'b001,
        CARREGANDO             		 = 3'b010,
        CORRENDO_MAPA          		 = 3'b011,
        PERCORRER_NUMEROS        	 = 3'b100,
        VITORIA 					 = 3'b101,
        DERROTA						 = 3'b110;
    
    assign index = pos_i * 9 + pos_j;
    assign cell_visibility_value = visibilities[index];
    assign cell_value = cell_visibility_value ? board[index +: 4] : 4'b0000;

    assign playing_condition = (current_state == CORRENDO_MAPA) || (current_state == PERCORRER_NUMEROS);

    // --- outputs
    assign n3 = {3'b000, start_button};
    assign n4 = {1'b0, current_state};
    assign n5 = cell_value;
    assign n6 = pos_j;
    assign n7 = pos_i;
    // --- states
    assign states = {current_state == INICIAR_JOGO,
                     current_state == SELECIONAR_DIFICULDADE,
                     current_state == CARREGANDO,
                     current_state == CORRENDO_MAPA,
                     current_state == PERCORRER_NUMEROS,
                     current_state == VITORIA,
                     current_state == DERROTA};
    // ---

    score game_score (
        .clk(game_clk),
        .timer(timer),
        .playing_condition(playing_condition),
        .score(score)
    );

    board_updater #(
        .CARREGANDO(CARREGANDO),
        .PERCORRER_NUMEROS(PERCORRER_NUMEROS)
    ) board_updater (
        .clk(game_clk),
        .reset(reset),
        .up_button(up_button),
        .down_button(down_button),
        .a_button(a_button),
        .b_button(b_button),
        .index(index),
        .cell_value(cell_value),
        .current_state(current_state),

        .selected_visibility(selected_visibility),
        .selected_map(selected_map),
        .visibilities(visibilities),
        .board(board),

        .error(error),
        .strikes(strikes),
        .selected_number(selected_number)
    );

    position_updater #(
        .CORRENDO_MAPA(CORRENDO_MAPA)
    ) position_updater (
        .clk(clk),
        .reset(reset),
        .up_button(up_button),
        .down_button(down_button),
        .left_button(left_button),
        .right_button(right_button),
        .current_state(current_state),
        .pos_i(pos_i),
        .pos_j(pos_j)
    );

    difficulty_selector #(
        .SELECIONAR_DIFICULDADE(SELECIONAR_DIFICULDADE)
    ) difficulty_selector (
        .clk(clk),
        .reset(reset),
        .up_button(up_button),
        .down_button(down_button),
        .current_state(current_state),
        .difficulty(difficulty)
    );

    result result (
        .timer(timer),
        .difficulty(difficulty),
        .strikes(strikes),
        .visibilities(visibilities),
        .victory_condition(victory_condition),
        .defeat_condition(defeat_condition)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= INICIAR_JOGO;
        end else begin
            current_state <= next_state;
        end
    end
    
    always @(*) begin
        next_state = current_state;

        case (current_state)
            INICIAR_JOGO: begin
                if (start_button) begin
                    next_state = SELECIONAR_DIFICULDADE;
                end
            end
            SELECIONAR_DIFICULDADE: begin
                if (a_button) begin
                    next_state = CARREGANDO;
                end
            end
            CARREGANDO: begin
                if (start_button) begin
                    next_state = CORRENDO_MAPA;
                end
            end
            CORRENDO_MAPA: begin
                if (a_button & ~cell_visibility_value) begin
                    next_state = PERCORRER_NUMEROS;
                end
            end
            PERCORRER_NUMEROS: begin
                if ((a_button && cell_value == selected_number) || b_button) begin
                    next_state = CORRENDO_MAPA;
                end
            end
            VITORIA: begin
                if (start_button) begin
                    next_state = SELECIONAR_DIFICULDADE;
                end
            end
            DERROTA: begin
                if (start_button) begin
                    next_state = SELECIONAR_DIFICULDADE;
                end
            end
        endcase

        if (victory_condition) begin
            next_state = VITORIA;
        end

        if (defeat_condition) begin
            next_state = DERROTA;
        end
    end
endmodule
