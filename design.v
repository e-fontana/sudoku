module top(
    CLOCK_50,
    reset,

    // Controller signals
    GPIO,
    select,
    
    // leds
    led1,
    led2,
    led3,
    led4,
    led5,
    led6,

    // UART signals
    tx,
    busy
);
    input CLOCK_50, reset;
    output select;
    output led1, led2, led3, led4, led5, led6;

    wire [5:0] LEDG;
    
    assign led1 = LEDG[0];
    assign led2 = LEDG[1];
    assign led3 = LEDG[2];
    assign led4 = LEDG[3];
    assign led5 = LEDG[4];
    assign led6 = LEDG[5];

    inout [35:0] GPIO;

    controller_top controller (
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .LEDG(LEDG),
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