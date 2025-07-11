module result #(
    parameter LIMIT_MINUTES = 5
) (
    input [10:0] timer,
    input difficulty,
    input [1:0] strikes,
    input [80:0] visibilities,
    output victory_condition,
    output defeat_condition
);
    localparam TIME_LIMIT = LIMIT_MINUTES * 60;
    assign victory_condition = &visibilities && (strikes != 2'b11) && (timer < TIME_LIMIT);
    assign defeat_condition = (difficulty && (strikes == 2'b11)) || timer >= TIME_LIMIT;
endmodule
