module defeat(
    input timer,
    input difficulty,
    input [1:0] strikes,
    output defeat_condition
);
    localparam [10:0] TIME_LIMIT = 11'd1800;
    assign defeat_condition = (difficulty && (strikes == 2'b11)) || timer == TIME_LIMIT;
endmodule