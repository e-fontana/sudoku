module led_on_pulse (
    input  wire clk,          // Clock de 50MHz
    input  wire reset,        // Reset assíncrono
    input  wire pulse_in,     // Pulso de 1 ciclo (vindo do controller_output[i])
    output reg  led_out       // LED ligado por 1 segundo
);
    localparam ON_TIME = 50_000_000; // 1s @ 50MHz

    reg [25:0] counter = 0; // 26 bits suficientes para contar até 50 milhões
    reg active = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            active <= 0;
            led_out <= 0;
        end else begin
            if (pulse_in && !active) begin
                // Pulso detectado, inicia contagem
                active <= 1;
                counter <= 1;
                led_out <= 1;
            end else if (active) begin
                if (counter >= ON_TIME) begin
                    active <= 0;
                    counter <= 0;
                    led_out <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end
endmodule
