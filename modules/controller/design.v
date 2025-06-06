module controller_top (
    input wire CLOCK_50,
    input wire reset,
    output wire [7:0] LEDG,
    inout wire [35:0] GPIO
);
    wire controller_select_out;

    controller_reader controller (
        .clk(CLOCK_50),
        .reset(reset),
        .leds(LEDG),

        .select_out(controller_select_out),
        .data_up(GPIO[35]),
        .data_down(GPIO[31]),
        .data_left(GPIO[27]),
        .data_right(GPIO[25]),
        .data_pin_ab(GPIO[33]),
        .data_pin_start_c(GPIO[23])
    );

    assign GPIO[29] = controller_select_out;

endmodule