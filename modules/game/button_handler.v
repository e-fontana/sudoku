module button_handler (
    input original_up_button,
    input original_down_button,
    input original_left_button,
    input original_right_button,
    output up_button,
    output down_button,
    output left_button,
    output right_button
);
    assign up_button = original_up_button;
    assign down_button = original_down_button;
    assign left_button = original_left_button;
    assign right_button = original_right_button;
endmodule