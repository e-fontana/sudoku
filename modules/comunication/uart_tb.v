`timescale 1ns/1ps

module uart_tb;
    reg clk = 0;
    reg rst = 1;
    wire tx;

    uart_test_top dut (
        .clk(clk),
        .rst(rst),
        .tx(tx)
    );

    initial begin
        #100 rst = 0;
        #10000000 $finish;
    end

    always #10 clk = ~clk; // 50 MHz

endmodule
