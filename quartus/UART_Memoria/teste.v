module UART_Test_AA (
    input clock,
    input reset,
    output [7:0] tx_data,
    output tx_start,
    input tx_busy
);

reg [7:0] tx_data_reg;
reg tx_start_reg;
reg [1:0] estado_atual, estado_futuro;

parameter IDLE = 2'b00,
          LOAD = 2'b01,
          START = 2'b10,
          WAIT = 2'b11;

// Registradores de estado
always @(posedge clock or posedge reset) begin
    if (reset) begin
        estado_atual <= IDLE;
    end else begin
        estado_atual <= estado_futuro;
    end
end

// Lógica de transição
always @(*) begin
    case (estado_atual)
        IDLE:
            if (!tx_busy)
                estado_futuro = LOAD;
            else
                estado_futuro = IDLE;
        LOAD:   estado_futuro = START;
        START:  estado_futuro = WAIT;
        WAIT:
            if (!tx_busy)
                estado_futuro = LOAD;
            else
                estado_futuro = WAIT;
        default: estado_futuro = IDLE;
    endcase
end

// Lógica de saída
always @(posedge clock or posedge reset) begin
    if (reset) begin
        tx_data_reg <= 8'h00;
        tx_start_reg <= 1'b0;
    end else begin
        case (estado_atual)
            LOAD: begin
                tx_data_reg <= 8'hAA; // valor fixo a ser enviado
                tx_start_reg <= 1'b0;
            end
            START: begin
                tx_start_reg <= 1'b1; // pulso de 1 ciclo
            end
            default: begin
                tx_start_reg <= 1'b0;
            end
        endcase
    end
end

assign tx_data = tx_data_reg;
assign tx_start = tx_start_reg;

endmodule
