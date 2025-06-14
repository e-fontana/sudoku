module sudoku(
    input up_button,
    input down_button,
    input left_button,
    input right_button,
    input start_button,
    input a_button,
    input b_button,
    input clk,
    input reset,
    input [404:0] selected_map,
    output reg [404:0] board,
    output cursor_x,
    output cursor_y,
    output reg error
);
    reg strikes = 0;

    reg [2:0] current_state;
    reg difficulty;
    reg [3:0] selected_number;
    reg [3:0] pos_x;
    reg [3:0] pos_y;
    wire [4:0] cell_value;
    wire index;
    
    assign index = (pos_x * 5) + (pos_y * 45);
    assign cell_value = board[index +: 5];
    assign cursor_x = pos_x;
    assign cursor_y = pos_y;

    parameter [2:0] 
        INICIAR_JOGO        		 = 3'b000,
        SELECIONAR_DIFICULDADE 	     = 3'b001,
        CARREGANDO             		 = 3'b010,
        CORRENDO_MAPA          		 = 3'b011,
        PERCORRER_NUMEROS        	 = 3'b100,
        VITORIA 					 = 3'b101,
        DERROTA						 = 3'b110;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            board <= selected_map;
            current_state <= INICIAR_JOGO;
            difficulty <= 2'b01;
            cursor_x <= 4'b0100;
            cursor_y <= 4'b0100;
            selected_number <= 4'b0000;
        end else begin
            case (current_state)
                INICIAR_JOGO: begin
                    if (start_button) begin
                        current_state <= SELECIONAR_DIFICULDADE;
                    end
                end
                SELECIONAR_DIFICULDADE: begin
                    if (up_button) begin
                        difficulty <= 0;
                    end else if (down_button) begin
                        difficulty <= 1;
                    end
                    if (a_button) begin
                        current_state <= CORRENDO_MAPA;
                    end
                end
                CORRENDO_MAPA: begin
                    if (up_button && pos_y > 0) begin
                        pos_y <= pos_y - 1;
                    end
                    if (down_button && pos_y < 8) begin
                        pos_y <= pos_y + 1;
                    end
                    if (left_button && pos_x > 0) begin
                        pos_x <= pos_x - 1;
                    end
                    if (right_button && pos_x < 8) begin
                        pos_x <= pos_x + 1;
                    end
                    if (a_button && cell_value[4] == 1'b0) begin
                        current_state <= PERCORRER_NUMEROS;
                    end
                end
                PERCORRER_NUMEROS: begin
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
                    if (a_button) begin
                        if (cell_value[3:0] == selected_number) begin
                            board[index +: 5] <= {1'b1, selected_number};
                            current_state <= CORRENDO_MAPA;
                        end
                        else begin
                            strikes <= strikes + 1;
                            error <= 1'b1;
                        end
                    end
                    if (b_button) begin
                        current_state <= CORRENDO_MAPA;
                    end
                end
                VITORIA: begin
                    if (start_button) begin
                        current_state <= SELECIONAR_DIFICULDADE;
                    end
                end
                DERROTA: begin
                    if (start_button) begin
                        current_state <= SELECIONAR_DIFICULDADE;
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        integer count = 0;

        for (integer i = 0; i < 405; i = i + 5) begin
            if (board[i + 4] != 1'b1) begin
                count = count + 1;
            end
        end

        if (count == 81) begin
            current_state <= VITORIA;
        end
    end

endmodule