module test_defs(
    input test,
    output [2:0] current_state,
    output game_dificulty,
    output [323:0] full_board,
    output [161:0] colors,
    output [7:0] position,
    output [1:0] errors,
    output [3:0] selected_number,
    output victory_condition,
    output [6:0] score,
    output [10:0] time_in_seconds
);
    localparam CORES_TEST = 162'b001010101111001101111001010100010110101111001100001111001010110010110101010101101010111100110111100101010001011010111100110000111100101011001011010101010110101011;
    localparam POSITION_TEST = {4'd5, 4'd8};
    localparam ERRORS_TEST = 2'd2;
    localparam SELECTED_NUMBER_TEST = 4'd3;

    assign current_state = test ? 3'b101 : 3'b110;
    assign game_dificulty = 1'b1;
    assign full_board = 324'h019638095430796528016975308406351927104860395726183049260187435962370481092635170;
    assign colors = CORES_TEST;
    assign position = POSITION_TEST;
    assign errors = ERRORS_TEST;
    assign selected_number = SELECTED_NUMBER_TEST;
    assign victory_condition = 1'b1;
    assign score = 7'd100;
    assign time_in_seconds = 11'h000;
endmodule