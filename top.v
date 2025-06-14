module top(
    input up_button,
    input down_button,
    input left_button,
    input right_button,
    input start_button,
    input a_button,
    input b_button,
    input clk,
    input reset,
    output [404:0] board,
    output cursor_x,
    output cursor_y,
    output error
);
    wire [404:0] map0, map1, map2, map3, map4, map5, map6, map7, map8, map9, map10, map11, map12, map13, map14, map15, map16, map17, map18, map19;
    wire [404:0] selected_map;

    assign selected_map = map0;

    sudoku sudoku_inst (
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
        .board(board),
        .cursor_x(cursor_x),
        .cursor_y(cursor_y),
        .error(error)
    );

    map map_inst (
        .map0(map0),
        .map1(map1),
        .map2(map2),
        .map3(map3),
        .map4(map4),
        .map5(map5),
        .map6(map6),
        .map7(map7),
        .map8(map8),
        .map9(map9),
        .map10(map10),
        .map11(map11),
        .map12(map12),
        .map13(map13),
        .map14(map14),
        .map15(map15),
        .map16(map16),
        .map17(map17),
        .map18(map18),
        .map19(map19)
    );

    score score_inst (
        .clk_50MHz(clk),
        .finish(start_button),
        .score(score),
        .timer(timer)
    );

    divisor divisor_inst (
        .clk_50MHz(clk),
        .clk_1Hz(clk_1Hz)
    );

    score score_inst (
        .clk_50MHz(clk),
        .finish(start_button),
        .score(score),
        .timer(timer)
    );
endmodule