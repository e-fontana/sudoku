module result(
    input [10:0] timer,
    input difficulty,
    input [1:0] strikes,
    input [80:0] visibilities,
    output victory_condition,
    output defeat_condition
);
    localparam [10:0] TIME_LIMIT = 11'd1800;
    assign victory_condition = &visibilities;
    assign defeat_condition = (difficulty && (strikes == 2'b11)) || timer == TIME_LIMIT;
endmodule