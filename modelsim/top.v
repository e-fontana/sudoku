module top(
    // clock and reset
    input reset,
    input clk,
    // buttons
    input a_button,
    input b_button,
    input original_up_button,
    input original_down_button,
    input original_left_button,
    input original_right_button,
    input start_button,
    // outputs
    output error,
    output difficulty,
    output [6:0] d0, d1, d2, d3, d4, d5, d6, d7
);
    wire [3:0] n0, n1, n2, n3, n4, n5, n6, n7;
    wire [80:0] selected_visibility;
    wire [323:0] selected_map;
    wire up_button, down_button, left_button, right_button;

    wire playing_condition;
    wire [6:0] score;
    wire [10:0] timer;
    wire [5:0] seconds;
    wire [4:0] minutes;
    wire [10:0] playtime;
    wire [3:0] pos_i, pos_j;

    wire [80:0] visibilities;
    wire [323:0] board;
    wire game_clk;

    assign n6 = pos_i;
    assign n7 = pos_j;

    assign playtime = {minutes, seconds};

    parameter GAME_FREQ = (50_000_000 - 1) / 8;
    frequency #(
        .COUNTER_LIMIT(GAME_FREQ)
    ) game_frequency (
        .clk(clk),
        .reset(reset),
        .out_clk(game_clk)
    );

    button_handler bh (
        .original_up_button(original_up_button),
        .original_down_button(original_down_button),
        .original_left_button(original_left_button),
        .original_right_button(original_right_button),
        .up_button(up_button),
        .down_button(down_button),
        .left_button(left_button),
        .right_button(right_button)  
    );

    display d (
        .n0(n0), .n1(n1), .n2(n2), .n3(n3),
        .n4(n4), .n5(n5), .n6(n6), .n7(n7),
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .d4(d4), .d5(d5), .d6(d6), .d7(d7)
    );

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
        .selected_visibility(selected_visibility),
        .selected_map(selected_map)
    );

    // game

    state_machine sm (
        .clk(game_clk),
        .reset(reset),
        .timer(timer),

        .up_button(up_button),
        .down_button(down_button),
        .left_button(left_button),
        .right_button(right_button),
        .start_button(start_button),
        .a_button(a_button),
        .b_button(b_button),

        .selected_visibility(selected_visibility),
        .selected_map(selected_map),

        .pos_i(pos_i),
        .pos_j(pos_j),
        .error(error),
        .score(score),

        .visibilities(visibilities),
        .board(board),
        
        .playing_condition(playing_condition),
        .difficulty(difficulty),
        .n0(n0), .n1(n1), .n2(n2), .n3(n3), .n4(n4), .n5(n5)
    );
endmodule
