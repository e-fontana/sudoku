module uart_tx8 (
    input clk,
    input rst,
    input [7:0] data,
    input start,
    output tx,
    output busy
);
    reg byte_start;
    wire tx_busy;
    reg sending;

    uart_tx uart (
        .clk(clk),
        .rst(rst),
        .data(data),
        .start(byte_start),
        .tx(tx),
        .busy(tx_busy)
    );

    assign busy = sending;

    // Máquina de estados para controlar o envio
    reg [1:0] state;
    localparam IDLE = 2'b00, START = 2'b01, WAIT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            byte_start <= 0;
            sending    <= 0;
            state      <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    byte_start <= 0;
                    if (start) begin
                        sending    <= 1;
                        state      <= START;
                    end
                end

                START: begin
                    byte_start <= 1;
                    state      <= WAIT;
                end

                WAIT: begin
                    byte_start <= 0;
                    if (!tx_busy) begin
                        sending <= 0;
                        state   <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
