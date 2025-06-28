module testbench;
    // clock and reset
    reg reset, clk;
    // buttons
    reg a_button, b_button, up_button, down_button, left_button, right_button, start_button;
    // outputs
    wire error;
    wire [3:0] pos_i;
    wire [3:0] pos_j;
    wire [6:0] score;
    wire [10:0] playtime;
    wire [404:0] board;

    top uut (
        .reset(reset),
        .clk(clk),
        .a_button(a_button),
        .b_button(b_button),
        .up_button(up_button),
        .down_button(down_button),
        .left_button(left_button),
        .right_button(right_button),
        .start_button(start_button),
        .error(error),
        .pos_i(pos_i),
        .pos_j(pos_j),
        .score(score),
        .playtime(playtime),
        .board(board)
    );

    wire [3:0] board_grid [0:8][0:8];
    generate
        genvar row;
        genvar col;
        for (row = 0; row < 9; row = row + 1) begin : gen_rows
            for (col = 0; col < 9; col = col + 1) begin : gen_cols
                localparam cell_index = (row * 9) + col;
                localparam start_bit = cell_index * 5;
                wire [4:0] raw_cell_bits = board[start_bit +: 5];
                assign board_grid[row][col] = (raw_cell_bits[4] == 1'b0) ? 4'b0000 : raw_cell_bits[3:0];
            end
        end
    endgenerate

    wire [3:0] board_position [0:1];
    assign board_position[0] = pos_i;
    assign board_position[1] = pos_j;

    wire [5:0] timer [0:1];
    assign timer[0] = {1'b0, playtime[10:6]};
    assign timer[1] = playtime[5:0];

    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    initial begin
        // Inicialização dos sinais
        #10 reset = 1; // Start with reset
        #20 reset = 0; // Release reset

        // Inicialização dos botões
        a_button = 0;
        b_button = 0;
        up_button = 0;
        down_button = 0;
        left_button = 0;
        right_button = 0;
        start_button = 0;

        // Tela inicial
        #30
        #10 start_button = 1; // Press start button
        #10 start_button = 0; // Release start button

        // Seleção de dificuldade
        #30
        #10 down_button = 1; // Press down button
        #10 down_button = 0; // Release down button
        #20
        #10 up_button = 1; // Press down button
        #10 up_button = 0; // Release down button
        #20
        #10 down_button = 1; // Press down button
        #10 down_button = 0; // Release down button

        // Iniciar jogo
        #30
        #10 a_button = 1; // Press a button
        #10 a_button = 0; // Release a button

        // Jogar
        #30
        // Posição inicial (4,4) centro do tabuleiro
        // Desclocar até (0,8)
        up;
        up;
        up;
        up;
        right;
        right;
        right;
        right;
        // colocar 4 no lugar que é um 4
        a;
        up;
        up;
        a;
        up;
        up;
        a;
        down;
        a;
        // deslocar até (6,0)
        left;
        left;
        left;
        left;
        left;
        left;
        left;
        left;
        down;
        down;
        down;
        down;
        down;
        down;
        // selecionar 1 e colocar em sua casa
        a;
        down;
        down;
        a; 
        
    end

    task up;
        begin
            #10 up_button = 1;
            #10 up_button = 0;
        end
    endtask

    task down;
        begin
            #10 down_button = 1;
            #10 down_button = 0;
        end
    endtask

    task left;
        begin
            #10 left_button = 1;
            #10 left_button = 0;
        end
    endtask

    task right;
        begin
            #10 right_button = 1;
            #10 right_button = 0;
        end
    endtask

    task a;
        begin
            #10 a_button = 1;
            #10 a_button = 0;
        end
    endtask

    task b;
        begin
            #10 b_button = 1;
            #10 b_button = 0;
        end
    endtask

    task start;
        begin
            #10 start_button = 1;
            #10 start_button = 0;
        end
    endtask
endmodule