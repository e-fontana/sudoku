module testbench;
    reg up_button;
    reg down_button;
    reg left_button;
    reg right_button;
    reg start_button;
    reg a_button;
    reg b_button;
    reg clk;
    reg reset;
    reg [4:0] board_scrapping [0:80];
    reg [404:0] initial_board;
    wire [404:0] board;

    sudoku uut (
        .up_button(up_button),
        .down_button(down_button),
        .left_button(left_button),
        .right_button(right_button),
        .start_button(start_button),
        .a_button(a_button),
        .b_button(b_button),
        .clk(clk),
        .reset(reset),
        .initial_board(initial_board),
        .board(board)
    );

    initial begin
        $readmemb("board.txt", board_scrapping);

        initial_board = 405'b0;
        for (integer i = 0; i < 81; i = i + 1) begin
            initial_board = initial_board | (board_scrapping[i] << (i * 5));
        end

        
    end
endmodule