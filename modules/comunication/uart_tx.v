module uart_tx (
    input clk,
    input rst,
    input start,
    input [7:0] data,
    output reg tx,
    output reg busy
);

    parameter BAUD_DIV = 115200; // 115200 baud com clock de 50 MHz

    reg [9:0] shift_reg;
    reg [15:0] baud_cnt;
    reg [3:0] bit_cnt;
    reg sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            busy <= 0;
            sending <= 0;
            baud_cnt <= 0;
            bit_cnt <= 0;
            shift_reg <= 10'b1111111111;
        end else begin
            if (!sending && start) begin
                shift_reg <= {1'b1, data, 1'b0};
                sending <= 1;
                busy <= 1;
                baud_cnt <= 0;
                bit_cnt <= 0;
            end else if (sending) begin
                if (baud_cnt == BAUD_DIV - 1) begin
                    baud_cnt <= 0;
                    tx <= shift_reg[0];
                    shift_reg <= {1'b1, shift_reg[9:1]};  // shift right com 1 na frente
                    bit_cnt <= bit_cnt + 1;

                    if (bit_cnt == 9) begin
                        sending <= 0;
                        busy <= 0;
                        tx <= 1; // idle state
                    end
                end else begin
                    baud_cnt <= baud_cnt + 1;
                end
            end
        end
    end

endmodule
