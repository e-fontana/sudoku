module button_debouncer (
    input  wire clk,
    input  wire reset,
    input  wire block,
    input  wire btn_in,         // botão original (1 = pressionado)
    output reg  btn_out         // pulso de 1 ciclo (1 = pressionado e validado)
);
    localparam S_IDLE         = 2'b00;
    localparam S_COUNT        = 2'b01;
    localparam S_PULSE        = 2'b10;
    localparam S_WAIT_RELEASE = 2'b11;

    // TODO: FIX COUNTER TARGET
    localparam COUNTER_TARGET = 100; // 1ms @ 50MHz

    reg [1:0] state = S_IDLE;
    reg [15:0] counter = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
            counter <= 0;
            btn_out <= 0;
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
                    end else if (counter == COUNTER_TARGET) begin
                        state <= S_PULSE;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                S_PULSE: begin
                    btn_out <= 1;     // pulso de 1 ciclo
                    state <= S_WAIT_RELEASE;
                end

                S_WAIT_RELEASE: begin
                    btn_out <= 0;
                    if (!btn_in || block) begin
                        state <= S_IDLE;
                    end
                end

                default: begin
                    state <= S_IDLE;
                    btn_out <= 0;
                end
            endcase
        end
    end
endmodule
