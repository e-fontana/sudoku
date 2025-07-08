module victory(
    input [80:0] visibilities,
    output victory_condition
);
    assign victory_condition = &visibilities;
endmodule