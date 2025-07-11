module button_handler (
    input clk,
    input reset,
    input original_up_button,
    input original_down_button,
    input original_left_button,
    input original_right_button,
    input original_start_button,
    input original_a_button,
    input original_b_button,
    output up_button,
    output down_button,
    output left_button,
    output right_button,
    output start_button,
    output a_button,
    output b_button
);

    assign up_button = !original_up_button;
    assign down_button = !original_down_button;
    assign left_button = !original_left_button;
    assign right_button = !original_right_button;

    assign start_button = original_start_button;
    assign a_button = original_a_button;
    assign b_button = original_b_button;
endmodule