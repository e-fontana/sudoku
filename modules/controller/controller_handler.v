module controller_handler(
    input           clk,
    input           reset_fixed,
    input           block_controller,
    input  [11:0]   controller_input,
    output [11:0]   LEDR,               // estado bruto dos botões
    output [11:0]   controller_output  // pulsos de 1 ciclo
);
    wire [11:0] debounced_output;

    genvar i;
    generate
        for (i = 0; i < 12; i = i + 1) begin: debounce_blocks
            // Módulo de debounce com pulso único
            button_debouncer db (
                .clk(clk),
                .reset_fixed(reset_fixed),
                .block(block_controller),
                .btn_in(controller_input[i]),
                .btn_out(debounced_output[i])
            );
            led_on_pulse led_module (
                .clk(clk),
                .reset_fixed(reset_fixed),
                .pulse_in(controller_output[i]),
                .led_out(LEDR[i])
            );
        end
    endgenerate

    assign controller_output = debounced_output;
endmodule
