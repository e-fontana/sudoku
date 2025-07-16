module display(
    input [3:0] n0, n1, n2, n3, n4, n5, n6, n7,
    output [6:0] d0, d1, d2, d3, d4, d5, d6, d7
);
    parameter n = 70'b1000000111100101001000110000001100100100100000010111100000000000010000;
    
    assign d0 = n[69 - (n0 * 7) -: 7];
    assign d1 = n[69 - (n1 * 7) -: 7];
    assign d2 = n[69 - (n2 * 7) -: 7];
    assign d3 = n[69 - (n3 * 7) -: 7];
    assign d4 = n[69 - (n4 * 7) -: 7];
    assign d5 = n[69 - (n5 * 7) -: 7];
    assign d6 = n[69 - (n6 * 7) -: 7];
    assign d7 = n[69 - (n7 * 7) -: 7];
endmodule