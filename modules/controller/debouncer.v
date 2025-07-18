module button_debouncer (
    input  wire clk,
    input  wire reset_fixed,
    input  wire block,
    input  wire btn_in,         // botão original (1 = pressionado)
    output reg  btn_out         // pulso de 1 ciclo (1 = pressionado e validado)
);

    localparam S_IDLE         = 3'b000;
    localparam S_COUNT        = 3'b001;
    localparam S_PULSE        = 3'b010;
    localparam S_WAIT_RELEASE = 3'b011;
    localparam S_REPEAT       = 3'b100;

    localparam DEBOUNCE_COUNT = 50;       // 1ms @ 50MHz (ajuste conforme necessário)
    localparam REPEAT_COUNT   = 7_999_999; // 100ms @ 50MHz (pulso periódico)

    reg [2:0] state = S_IDLE;
    reg [22:0] counter = 0; // Largura suficiente para até ~8M

    always @(posedge clk or negedge reset_fixed) begin
        if (!reset_fixed) begin
            state    <= S_IDLE;
            counter  <= 0;
            btn_out  <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    btn_out <= 0;
                    counter <= 0;
                    if (!block && btn_in) begin
                        state <= S_COUNT;
                        counter <= 1;
                    end
                end

                S_COUNT: begin
                    btn_out <= 0;
                    if (block || !btn_in) begin
                        state <= S_IDLE;
                        counter <= 0;
                    end else if (counter >= DEBOUNCE_COUNT) begin
                        state <= S_PULSE;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                S_PULSE: begin
                    btn_out <= 1;
                    counter <= 0;
                    if (btn_in)
                        state <= S_REPEAT;
                    else
                        state <= S_WAIT_RELEASE;
                end

                S_REPEAT: begin
                    btn_out <= 0;
                    if (!btn_in) begin
                        state <= S_WAIT_RELEASE;
                        counter <= 0;
                    end else begin
                        if (counter >= REPEAT_COUNT) begin
                            btn_out <= 1;     // novo pulso
                            counter <= 0;
                        end else begin
                            counter <= counter + 1;
                        end
                    end
                end

                S_WAIT_RELEASE: begin
                    btn_out <= 0;
                    if (!btn_in) begin
                        if (counter >= DEBOUNCE_COUNT) begin
                            state <= S_IDLE;
                            counter <= 0;
                        end else begin
                            counter <= counter + 1;
                        end
                    end else begin
                        counter <= 0;
                    end
                end

                default: begin
                    state <= S_IDLE;
                    btn_out <= 0;
                    counter <= 0;
                end
            endcase
        end
    end
endmodule
