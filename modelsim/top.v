module top(
    // clock and reset
    input reset,
    input clk,
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
    output [3:0] pos_i,
    output [3:0] pos_j,
    output [6:0] score,
    output [10:0] playtime,
    output [404:0] board
);
    wire [404:0] selected_map;
    wire playing_condition;
    wire [10:0] timer;
    wire [5:0] seconds;
    wire [4:0] minutes;

    assign playtime = {minutes, seconds};

    stopwatch sw (
        .clk(clk),
        .reset(reset),
        .playing_condition(playing_condition),
        .timer(timer),
        .seconds(seconds),
        .minutes(minutes)
    );

    score sc (
        .clk(clk),
        .timer(timer),
        .playing_condition(playing_condition),
        .score(score)
    );

    // map

    map_selector ms (
        .clk(clk),
        .reset(reset),
        .selected_map(selected_map)
    );

    // game

    state_machine sm (
        .clk(clk),
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
        .pos_i(pos_i),
        .pos_j(pos_j),
        .error(error),
        .score(score),
        .board(board),
        .playing_condition(playing_condition)
    );
endmodule
