module controller(
    input clk.
    input reset,

    input block_controller,
    input [11:0] controller_input,

    output [11:0] LEDR,
    output [11:0] controller_output
);

    reg up, down, left, right, a, b, c, output_x, y, output_z, start, mode = 1'b0;

    localparam BUTTON_COUNTER_TARGET = 50_000;
    localparam LED_COUNTER_TARGET    = 50_000_000;

    localparam S_IDLE         = 2'b00; // Esperando o botão ser pressionado
    localparam S_WAIT         = 2'b01; // Botão pressionado, esperando o tempo de 1ms
    localparam S_PULSE        = 2'b10; // Gera o pulso de saída de 1 ciclo
    localparam S_WAIT_RELEASE = 2'b11; // Esperando o botão ser solto

    genvar i;
    generate
        for (i = 0; i < 12; i = i + 1) begin: button_and_led_logic
            
            // --- Registradores para a lógica de validação do botão ---
            reg [1:0]  button_state_reg;
            reg [15:0] button_counter_reg; // Contador de até 16 bits para 50.000

            // --- Registradores para a lógica do temporizador do LED ---
            reg        led_state_reg; // 0 = OFF, 1 = ON
            reg [25:0] led_counter_reg;  // Contador de 26 bits para 50.000.000

            always @(posedge clk or posedge reset) begin
                if (reset) begin
                    // Reseta a lógica de validação do botão
                    button_state_reg   <= S_IDLE;
                    button_counter_reg <= 0;
                    controller_output[i] <= 1'b0;

                    // Reseta a lógica do LED
                    led_state_reg      <= 1'b0; // LED desligado
                    led_counter_reg    <= 0;
                    LEDR[i]              <= 1'b0;
                
                // Se o controlador estiver bloqueado, desliga tudo
                end else if (block_controller) begin
                    button_state_reg   <= S_IDLE;
                    button_counter_reg <= 0;
                    controller_output[i] <= 1'b0;
                    led_state_reg      <= 1'b0;
                    led_counter_reg    <= 0;
                    LEDR[i]              <= 1'b0;
                    
                end else begin
                    // =======================================================
                    //  1. LÓGICA DE VALIDAÇÃO DO BOTÃO (gera o pulso)
                    // =======================================================
                    case (button_state_reg)
                        S_IDLE: begin
                            controller_output[i] <= 1'b0;
                            if (controller_input[i] == 1'b1) begin
                                button_state_reg   <= S_WAIT;
                                button_counter_reg <= 0;
                            end
                        end
                        S_WAIT: begin
                            if (controller_input[i] == 1'b1) begin
                                if (button_counter_reg == BUTTON_COUNTER_TARGET) begin
                                    button_state_reg <= S_PULSE;
                                end else begin
                                    button_counter_reg <= button_counter_reg + 1;
                                end
                            end else begin
                                button_state_reg <= S_IDLE;
                            end
                        end
                        S_PULSE: begin
                            controller_output[i] <= 1'b1;
                            button_state_reg     <= S_WAIT_RELEASE;
                        end
                        S_WAIT_RELEASE: begin
                            controller_output[i] <= 1'b0;
                            if (controller_input[i] == 1'b0) begin
                                button_state_reg <= S_IDLE;
                            end
                        end
                        default: button_state_reg <= S_IDLE;
                    endcase

                    // =======================================================
                    //  2. LÓGICA DO TEMPORIZADOR DO LED (duração de 1s)
                    // =======================================================
                    // O pulso gerado em `controller_output` acima serve como gatilho.
                    // Se um novo pulso válido ocorrer, o timer de 1s é reiniciado.
                    if (controller_output[i] == 1'b1) begin
                        led_state_reg   <= 1'b1; // (Re)liga o LED
                        led_counter_reg <= 0;    // (Re)inicia o contador de 1s
                    
                    // Se não houve um novo pulso, mas o LED já está ligado...
                    end else if (led_state_reg == 1'b1) begin
                        // Verifica se o tempo de 1s terminou
                        if (led_counter_reg == LED_COUNTER_TARGET) begin
                            led_state_reg <= 1'b0; // Tempo esgotado, desliga o LED
                        end else begin
                            led_counter_reg <= led_counter_reg + 1; // Continua contando
                        end
                    end
                    
                    // Atribui o estado do temporizador à saída física do LED
                    LEDR[i] <= led_state_reg;
                end
            end
        end
    endgenerate

endmodule