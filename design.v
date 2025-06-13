module top(
    CLOCK_50,
    reset,

    // Controller signals
    GPIO,
    LEDR,

    // UART signals
    tx,
    busy
);
    input CLOCK_50, reset;

    output wire [11:0] LEDR;
    inout [35:0] GPIO;

    controller_top controller (
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .LEDR(LEDR),
        .GPIO(GPIO)
    );

    // UART signals
    output tx, busy;
    reg [7:0] data = 0;
    reg start = 0;
    reg uart_busy = 0;

    uart_tx8 uart (
        .clk(CLOCK_50),
        .rst(reset),
        .data(data),
        .start(start),
        .tx(tx),
        .busy(busy)
    );

endmodule