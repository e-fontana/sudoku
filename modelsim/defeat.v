module defeat(
    input difficulty,
    input [1:0] strikes,
    output defeat_condition
);
    assign defeat_condition = difficulty && (strikes == 2'b11);
endmodule