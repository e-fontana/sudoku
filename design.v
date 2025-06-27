module top(
    clock,
    reset,

    // Controller signals
    LEDR,
    controller_pins,
    controller_select,

    // UART signals
    tx,
    busy
);
    input clock, reset;
    
    input [5:0] controller_pins; 
    output controller_select; // GPIO[29]
    output wire [11:0] LEDR;

    reg [11:0] controller_output;

    assign LEDR = controller_output;

    controller_top controller (
        .clock(clock),
        .reset(reset),
    );

endmodule