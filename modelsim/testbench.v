module testbench;
    // clock and reset
    reg reset, clk_50MHz;
    // buttons
    reg a_button, b_button, up_button, down_button, left_button, right_button, start_button;
    // outputs
    wire error;
    wire [3:0] pos_x;
    wire [3:0] pos_y;
    wire [6:0] score;
    wire [10:0] timer;
    wire [404:0] board;

    top uut (
        .reset(reset),
        .clk_50MHz(clk_50MHz),
        .a_button(a_button),
        .b_button(b_button),
        .up_button(up_button),
        .down_button(down_button),
        .left_button(left_button),
        .right_button(right_button),
        .start_button(start_button),
        .error(error),
        .pos_x(pos_x),
        .pos_y(pos_y),
        .score(score),
        .timer(timer),
        .board(board)
    );

    initial begin
        clk_50MHz = 0;
        forever #2 clk_50MHz = ~clk_50MHz;
    end

    initial begin
        // Inicialização dos sinais
        #10 reset = 1; // Start with reset
        #10 reset = 0; // Release reset
        #30
        // Tela inicial
        #10 start_button = 1; // Press start button
        #10 start_button = 0; // Release start button
        // Seleção de dificuldade
        #10 down_button = 1; // Press down button
        #10 down_button = 0; // Release down button
        // Iniciar jogo
        #10 a_button = 1; // Press a button
        #10 a_button = 0; // Release a button
        #30
        $finish;
    end
endmodule