module defeat (
    input [10:0] timer,
    input difficulty,
    input [1:0] strikes,
    output defeat_condition
);
    localparam TIME_LIMIT = 600;
    assign defeat_condition = (difficulty && (strikes == 2'b11)) || timer == TIME_LIMIT;
endmodule