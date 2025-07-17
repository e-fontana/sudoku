module controller(
    input clk,
    input reset,
    input PIN_UP_Z,
    input PIN_DOWN_Y,
    input PIN_LEFT_X,
    input PIN_RIGHT_MODE,
    input PIN_A_B,
    input PIN_START_C,
    input [2:0] game_state,
    output select,
    output wire [11:0] LEDR,
    output wire [11:0] controller_output,
    output up_button, down_button, left_button, right_button, a_button, b_button, start_button, z_button
);
    wire [11:0] initial_ledr, reset_fixed;
    assign reset_fixed = ~reset;

    assign up_button = LEDR[11];
    assign down_button = LEDR[10];
    assign left_button = LEDR[9];
    assign right_button = LEDR[8];
    assign a_button = LEDR[7];
    assign b_button = LEDR[6];
    assign z_button = LEDR[2];
    assign start_button = LEDR[1];

    controller_reader reader (
        .clk(clk),
        .reset_fixed(reset_fixed),
        .PIN_UP_Z(PIN_UP_Z),
        .PIN_DOWN_Y(PIN_DOWN_Y),
        .PIN_LEFT_X(PIN_LEFT_X),
        .PIN_RIGHT_MODE(PIN_RIGHT_MODE),
        .PIN_A_B(PIN_A_B),
        .PIN_START_C(PIN_START_C),
        .game_state(game_state),
        .select(select),
        .LEDR(initial_ledr)
    );

    controller_handler handler (
        .clk(clk),
        .reset_fixed(reset_fixed),
        .block_controller(1'b0),
        .controller_input(initial_ledr),
        .LEDR(LEDR),
        .controller_output(controller_output)
    );
endmodule