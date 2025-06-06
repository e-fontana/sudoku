module uart_tx32 (
    input clk,
    input rst,
    // input [31:0] data,
    input start,
    output tx,
    output busy
);

    wire [7:0] current_byte;
    reg [1:0] byte_idx;
    reg byte_start;
    reg sending;
    reg [31:0] data_reg;
    wire tx_busy;

    assign current_byte = data_reg[7:0];

    wire [31:0] data = 32'hCAFEBABE;

    uart_tx uart (
        .clk(clk),
        .rst(rst),
        .data(current_byte),
        .start(byte_start),
        .tx(tx),
        .busy(tx_busy)
    );

    assign busy = sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sending <= 0;
            byte_start <= 0;
            byte_idx <= 0;
            data_reg <= 0;
        end else begin
            byte_start <= 0;
            if (start && !sending) begin
                sending <= 1;
                byte_idx <= 0;
                data_reg <= data;
            end else if (sending && !tx_busy) begin
                byte_start <= 1;
                data_reg <= data_reg >> 8;
                byte_idx <= byte_idx + 1;
                if (byte_idx == 3)
                    sending <= 0;
            end
        end
    end

endmodule
