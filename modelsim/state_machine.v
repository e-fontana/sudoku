module state_machine(
    // time
    input clk, reset,
    input [10:0] timer,
    // buttons
    input up_button, down_button, left_button, right_button, start_button, a_button, b_button,
    // map
    input [80:0] selected_visibility,
    input [323:0] selected_map,
    // outputs
    output [3:0] pos_i, pos_j,
    output [6:0] score,
    output error,

    output [80:0] visibilities,
    output [323:0] board,

    output playing_condition,
    output [3:0] n0, n6, n7
);
    reg [2:0] current_state, next_state;

    wire [6:0] index;
    wire [3:0] cell_value;
    wire [1:0] strikes;
    wire [3:0] selected_number;
    wire cell_visibility_value;

    wire difficulty;
    wire victory_condition, defeat_condition;
    
    parameter [2:0] 
        INICIAR_JOGO        		 = 3'b000,
        SELECIONAR_DIFICULDADE 	     = 3'b001,
        CARREGANDO             		 = 3'b010,
        CORRENDO_MAPA          		 = 3'b011,
        PERCORRER_NUMEROS        	 = 3'b100,
        VITORIA 					 = 3'b101,
        DERROTA						 = 3'b110;

    assign n0 = cell_value;
    assign n6 = {1'b0, current_state};
    assign n7 = {3'b000, difficulty};

    assign index = pos_i * 9 + pos_j;
    assign cell_value = board[index -: 4];
    assign cell_visibility_value = visibilities[index];

    assign playing_condition = (current_state == CORRENDO_MAPA || current_state == PERCORRER_NUMEROS);

    board_updater #(
        .PERCORRER_NUMEROS(PERCORRER_NUMEROS)
    ) b_up (
        .clk(clk),
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

    defeat d (
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
