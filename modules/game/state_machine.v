module state_machine #(
    parameter TIME_LIMIT_MINUTES = 5
) (
    // time
    input clk, reset,
    input [10:0] timer,
    // buttons
    input up_button, down_button, left_button, right_button, start_button, a_button, b_button,
    // map
    input [161:0] selected_visibility,
    input [323:0] selected_map,
    // timer and score
    input [6:0] score,
    input [4:0] minutes,
    input [5:0] seconds,
    // outputs
    output [3:0] pos_i, pos_j,
    output error,

    output [161:0] visibilities,
    output [323:0] board,

    output playing_condition,
    output difficulty,
    output [1:0] strikes,

    output [6:0] states,


    output [3:0] selected_number,

    output reg[2:0] current_state,

    output [3:0] n0, n1, n2, n3, n4, n5
);
    reg [2:0] next_state;

    wire [6:0] index;
    wire [8:0] board_index;
    wire [7:0] visibilities_index;
    wire [3:0] cell_value;
    wire cell_visibility_value;

    wire victory_condition, defeat_condition;
    wire [3:0] visible_cell_value;
    
    parameter [2:0] 
        INICIAR_JOGO        		 = 3'b000,
        SELECIONAR_DIFICULDADE 	     = 3'b001,
        CARREGANDO             		 = 3'b010,
        CORRENDO_MAPA          		 = 3'b011,
        PERCORRER_NUMEROS        	 = 3'b100,
        VITORIA 					 = 3'b101,
        DERROTA						 = 3'b110;

    assign n0 = playing_condition ? seconds % 10 : score % 10;
    assign n1 = playing_condition ? seconds / 10 : (score / 10) % 10;
    assign n2 = playing_condition ? minutes % 10 : score / 100;

    assign n3 = {2'b00, strikes};
    assign n4 = selected_number;
    assign n5 = visible_cell_value;

    assign index = pos_i * 9 + pos_j;
    assign visibilities_index = index * 2;
    assign board_index = index * 4;

    assign cell_value = board[board_index +: 4];
    assign cell_visibility_value = &visibilities[visibilities_index +: 2];
    assign visible_cell_value = cell_visibility_value ? cell_value : 4'b0000;

    assign playing_condition = (current_state == CORRENDO_MAPA || current_state == PERCORRER_NUMEROS);

    assign states = {
        current_state == INICIAR_JOGO,
        current_state == SELECIONAR_DIFICULDADE,
        current_state == CARREGANDO,
        current_state == CORRENDO_MAPA,
        current_state == PERCORRER_NUMEROS,
        current_state == VITORIA,
        current_state == DERROTA
    };

    board_updater #(
        .PERCORRER_NUMEROS(PERCORRER_NUMEROS)
    ) b_up (
        .clk(clk),
        .reset(reset),
        .left_button(left_button),
        .right_button(right_button),
        .a_button(a_button),
        .b_button(b_button),
        .index(visibilities_index),
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
    ) pos_up (
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
    ) d_sel (
        .clk(clk),
        .reset(reset),
        .up_button(up_button),
        .down_button(down_button),
        .current_state(current_state),
        .difficulty(difficulty)
    );
    
    victory v (
        .visibilities(visibilities),
        .victory_condition(victory_condition)
    );

    defeat #(
        .TIME_LIMIT_MINUTES(TIME_LIMIT_MINUTES)
    ) d (
        .timer(timer),
        .strikes(strikes),
        .difficulty(difficulty),
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
                if (|visibilities) begin
                    next_state = CORRENDO_MAPA;
                end
            end
            CORRENDO_MAPA: begin
                if (a_button & !cell_visibility_value) begin
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
