module controller_top (
    input wire clock,
    input wire reset,
    output reg flag
);
    localparam CLOCK_COUNTER = 32'd50000000;
    localparam FLAG_COUNTER = 16'd2000;

    reg [31:0] counter = 0;

    always @(posedge clock) begin
        if (reset) begin
            counter <= 0;
            flag <= 0;
        end
        else begin
            counter <= counter + 1;
            if (counter > 10 && counter < 20) begin
                flag <= 1;
            end
            else flag <= 0;
            if (counter >= CLOCK_COUNTER) begin
                counter <= 0;
            end
        end
    end
endmodule