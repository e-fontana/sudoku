module victory(
    input [161:0] visibilities,
    output victory_condition
);
    assign victory_condition = &visibilities;
endmodule