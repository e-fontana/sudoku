module controller(
    input           clk,
    input           reset,
    input           block_controller,
    input  [11:0]   controller_input,
    output [11:0]   LEDR,
    output [11:0]   controller_output
);
    wire [11:0] debouncer_output;

    assign controller_output = debouncer_output;

    genvar i;
    generate
        for (i = 0; i < 12; i = i + 1) begin: debounce_blocks
            button_debouncer debouncer_inst (
                .clk(clk),
                .reset(reset),
                .block(block_controller),
                .btn_in(controller_input[i]),
                .btn_out(debouncer_output[i])
            );
            led_on_pulse led_module (
                .clk(clk),
                .reset(reset),
                .pulse_in(controller_output[i),
                .led_out(LEDR[i])
            );
        end
    endgenerate

endmodule
