module top(
    input wire CLOCK_50,
    input wire reset,
    output wire [7:0] LEDG,
    inout wire [35:0] GPIO
);
    reg [7:0] GPIO_DATA = 0;

    controller_top controller (
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .LEDG(LEDG),
        .GPIO(GPIO)
    )

    @always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin
            GPIO_DATA <= 8'b0;
        end else begin
            GPIO_DATA <= LEDG;
        end
    end

endmodule