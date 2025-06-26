module state_machine(
    // time
    input clk,
    input reset,
    input [10:0] timer,
    // buttons
    input up_button,
    input down_button,
    input left_button,
    input right_button,
    input start_button,
    input a_button,
    input b_button,
    // selected map
    input [404:0] selected_map,
    // outputs
    output [3:0] pos_x,
    output [3:0] pos_y,
    output [6:0] score,
    output reg error,
    output reg [404:0] board
);
    reg difficulty;
    reg [2:0] strikes;
    reg [3:0] cursor_x;
    reg [3:0] cursor_y;
    reg [2:0] current_state, next_state;
    reg [3:0] selected_number;

    wire [8:0] index;
    wire [4:0] cell_value;
    wire victory_condition;
    wire defeat_condition;
    wire playing_condition;
    
    parameter [2:0] 
        INICIAR_JOGO        		 = 3'b000,
        SELECIONAR_DIFICULDADE 	     = 3'b001,
        // CARREGANDO             		 = 3'b010,
        CORRENDO_MAPA          		 = 3'b011,
        PERCORRER_NUMEROS        	 = 3'b100,
        VITORIA 					 = 3'b101,
        DERROTA						 = 3'b110;

    assign pos_x = cursor_x;
    assign pos_y = cursor_y;

    assign index = (pos_x * 5) + (pos_y * 45);
    assign cell_value = board[index +: 5];

    assign playing_condition = (current_state == CORRENDO_MAPA || current_state == PERCORRER_NUMEROS);
    
    score sc (
        .clk(clk),
        .timer(timer),
        .playing_condition(playing_condition),
        .score(score)
    );
    
    victory v (
        .board(board),
        .victory_condition(victory_condition)
    );

    defeat d (
        .strikes(strikes),
        .difficulty(difficulty),
        .defeat_condition(defeat_condition)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            board <= selected_map;
            current_state <= INICIAR_JOGO;

            error <= 1'b0;
            strikes <= 3'b000;
            difficulty <= 1'b0;
            cursor_x <= 4'b0100;
            cursor_y <= 4'b0100;
            selected_number <= 4'b0000;
        end else begin
            current_state <= next_state;
        end
    end
    
    always @(*) begin
        next_state = current_state;
        case (current_state)
            INICIAR_JOGO: begin
                if (start_button) begin
                    next_state <= SELECIONAR_DIFICULDADE;
                end
            end
            SELECIONAR_DIFICULDADE: begin
                if (up_button) begin
                    difficulty <= 0;
                end else if (down_button) begin
                    difficulty <= 1;
                end

                if (a_button) begin
                    next_state <= CORRENDO_MAPA;
                end
            end
            CORRENDO_MAPA: begin
                // navegando pelo mapa
                if (up_button && pos_y > 0) begin
                    cursor_y <= pos_y - 1;
                end
                if (down_button && pos_y < 8) begin
                    cursor_y <= pos_y + 1;
                end
                if (left_button && pos_x > 0) begin
                    cursor_x <= pos_x - 1;
                end
                if (right_button && pos_x < 8) begin
                    cursor_x <= pos_x + 1;
                end

                // selecionando a célula caso esteja vazia
                if (a_button && cell_value[4] == 1'b0) begin
                    next_state <= PERCORRER_NUMEROS;
                end

                // verificando fim de jogo
                if (victory_condition) begin
                    next_state <= VITORIA;
                end else if (defeat_condition) begin
                    next_state <= DERROTA;
                end
            end
            PERCORRER_NUMEROS: begin
                // navegando pelos números
                if (up_button) begin
                    if (selected_number < 9) selected_number <= selected_number + 1;
                    else selected_number <= 4'd1;
                    error <= 1'b0;
                end
                else if (down_button) begin
                    if (selected_number > 1) selected_number <= selected_number - 1;
                    else selected_number <= 4'd9;
                    error <= 1'b0;
                end
                
                // verificando se o número selecionado é válido
                if (a_button) begin
                    if (cell_value[3:0] == selected_number) begin
                        board[index +: 5] <= {1'b1, selected_number};
                        next_state <= CORRENDO_MAPA;
                    end
                    else begin
                        strikes <= strikes + 1;
                        error <= 1'b1;
                    end
                end

                // voltar para o mapa
                if (b_button) begin
                    next_state <= CORRENDO_MAPA;
                end
            end
            VITORIA: begin
                if (start_button) begin
                    next_state <= SELECIONAR_DIFICULDADE;
                end
            end
            DERROTA: begin
                if (start_button) begin
                    next_state <= SELECIONAR_DIFICULDADE;
                end
            end
        endcase
    end
endmodule
