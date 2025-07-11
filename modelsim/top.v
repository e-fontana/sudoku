module top(
    // clock and reset
    input reset,
    input clk,
    // buttons
    input original_a_button,
    input original_b_button,
    input original_up_button,
    input original_down_button,
    input original_left_button,
    input original_right_button,
    input original_start_button,
    // outputs
    output error, difficulty, playing_condition,
    output up_button, down_button, left_button, right_button, start_button, a_button, b_button,
    output [6:0] states, d0, d1, d2, d3, d4, d5, d6, d7
);
    wire clk_1Hz, game_clk;
    wire [3:0] n0, n1, n2, n3, n4, n5, n6, n7;

    wire [323:0] selected_map;
    wire [80:0] selected_visibility;
    wire [10:0] timer;

    button_handler bh (
        // inputs
        .clk(clk),
        .reset(reset),
        .original_up_button(original_up_button),
        .original_down_button(original_down_button),
        .original_left_button(original_left_button),
        .original_right_button(original_right_button),
        .original_start_button(original_start_button),
        .original_a_button(original_a_button),
        .original_b_button(original_b_button),
        // outputs
        .up_button(up_button),
        .down_button(down_button),
        .left_button(left_button),
        .right_button(right_button),
        .start_button(start_button),
        .a_button(a_button),
        .b_button(b_button)
    );

    display d (
        .n0(n0), .n1(n1), .n2(n2), .n3(n3),
        .n4(n4), .n5(n5), .n6(n6), .n7(n7),
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .d4(d4), .d5(d5), .d6(d6), .d7(d7)
    );

    stopwatch_frequency stopwatch_frequency (
        .clk(clk),
        .reset(reset),
        .stopwatch_clk(clk_1Hz)
    );

    stopwatch stopwatch (
        .clk(clk_1Hz),
        .reset(reset),
        .playing_condition(playing_condition),
        .timer(timer),

        .n0(n0), .n1(n1), .n2(n2)
    );

    // map

    map_selector ms (
        .clk(game_clk),
        .reset(reset),
        .selected_visibility(selected_visibility),
        .selected_map(selected_map)
    );

    game_frequency game_frequency (
        .clk(clk),
        .reset(reset),
        .game_clk(game_clk)
    );

    // game

    game_state_machine game_state_machine (
        // inputs
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
        // outputs
        .error(error),
        .difficulty(difficulty),
        .playing_condition(playing_condition),
        
        .n3(n3), .n4(n4), .n5(n5), .n6(n6), .n7(n7)
    );
endmodule
