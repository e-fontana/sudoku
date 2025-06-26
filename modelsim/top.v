module top(
    // clock and reset
    input reset,
    input clk_50MHz,
    // buttons
    input a_button,
    input b_button,
    input up_button,
    input down_button,
    input left_button,
    input right_button,
    input start_button,
    // outputs
    output error,
    output [3:0] pos_x,
    output [3:0] pos_y,
    output [6:0] score,
    output [10:0] timer,
    output [404:0] board
);
    wire clk_1Hz;
    wire [404:0] selected_map;

    // time

    frequency fd (
        .clk_50MHz(clk_50MHz),
        .clk_1Hz(clk_1Hz)
    );

    stopwatch sw (
        .clk(clk_1Hz),
        .reset(reset),
        .timer(timer)
    );

    // map

    map_selector ms (
        .clk(clk_1Hz),
        .reset(reset),
        .selected_map(selected_map)
    );

    // game

    state_machine sm (
        .clk(clk_50MHz),
        .reset(reset),
        .timer(timer),
        .up_button(up_button),
        .down_button(down_button),
        .left_button(left_button),
        .right_button(right_button),
        .start_button(start_button),
        .a_button(a_button),
        .b_button(b_button),
        .selected_map(selected_map),
        .pos_x(pos_x),
        .pos_y(pos_y),
        .error(error),
        .score(score),
        .board(board)
    );
endmodule
