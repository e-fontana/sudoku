module controller_top (
    input wire CLOCK_50,
    input wire reset,
    output wire select,
    output wire [5:0] LEDG,
    inout wire [35:0] GPIO
);

    controller_reader controller (
        .clk(CLOCK_50),
        .leds(LEDG),

        .p7(select),
        .up(GPIO[35]),
        .dw(GPIO[31]),
        .lf(GPIO[27]),
        .rg(GPIO[25]),
        .a(GPIO[33]),
        .b(GPIO[33]),
        .c(GPIO[23]),
        .st(GPIO[23])
    );

    assign GPIO[29] = select;

endmodule