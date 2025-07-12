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
endmodule
