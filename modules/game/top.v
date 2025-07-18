module game(
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
    output [6:0] states,
    output [2:0] current_state,
    output [6:0] d0, d1, d2, d3, d4, d5, d6, d7,
    output [323:0] board,
    output [161:0] visibilities,
    output [7:0] position,
    output [1:0] strikes,
    output [3:0] selected_number,
    output [6:0] score,
	output [10:0] stopwatch
);
    wire [3:0] n0, n1, n2, n3, n4, n5, n6, n7;
    wire [161:0] selected_visibility;
    wire [323:0] selected_map;
    wire up_button, down_button, left_button, right_button;

    wire playing_condition;
    wire [10:0] timer;
    wire [5:0] seconds;
    wire [4:0] minutes;
    wire [3:0] pos_i, pos_j;

	 assign stopwatch = {minutes, seconds};
    assign n6 = pos_j;
    assign n7 = pos_i;
    assign position = {pos_i, pos_j};

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
        .reset(reset),
        .timer(timer),
        .score(score)
    );

    // map

    map_selector ms (
        .clk(game_clk),
        .reset(reset),
        .difficulty(difficulty),
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

        .score(score),
        .minutes(minutes),
        .seconds(seconds),

        .pos_i(pos_i),
        .pos_j(pos_j),
        .error(error),

        .visibilities(visibilities),
        .board(board),
        
        .playing_condition(playing_condition),
        .difficulty(difficulty),
        .strikes(strikes),

        .states(states),
        .selected_number(selected_number),
        .current_state(current_state),

        .n0(n0), .n1(n1), .n2(n2), .n3(n3), .n4(n4), .n5(n5)
    );
endmodule
