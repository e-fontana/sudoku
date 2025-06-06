module uart_test_top;
    reg [23:0] counter;
    reg send;
    wire busy;
    
    wire clk;
    wire rst;
    wire tx;

    uart_tx32 tx32 (
        .clk(clk),
        .rst(rst),
        .start(send),
        .tx(tx),
        .busy(busy)
    );

    begin
        reset = 1;
        #100 reset = 0; // Release reset after 100 ns
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            send <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 24'hFFFFFF) begin
                send <= 1;
            end else begin
                send <= 0;
            end
        end
    end

endmodule
