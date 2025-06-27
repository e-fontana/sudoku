module controller_top (
    input wire clock,
    input wire reset,
    output reg flag
);
    localparam CLOCK_COUNTER = 32'd50000000;
    localparam FLAG_COUNTER = 16'd2000;

    reg [31:0] counter = 0;

    always @(posedge clock) begin
        if (counter == (CLOCK_COUNTER + FLAG_COUNTER)) begin
            flag <= 0;
            counter <= 0;
        end
        else if (counter == CLOCK_COUNTER) flag <= 1;
        else begin
            counter <= counter + 1;
        end
    end 

    controller_reader controller (
        .clock(clock),
        .reset(reset),
        .flag(flag),
    );
endmodule