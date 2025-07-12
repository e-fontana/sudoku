module colors(
    input [80:0] visibilities,
    input [323:0] board
    input [3:0] pos_i, pos_j
    output reg [1:0] color
);
    wire [8:0] index;
    assign index =(pos_i+*9+pos_j)*4;

    always @(*) begin
        if(error) begin
            color = 2'b10;
        end else if(visibilities[index])begin
            color = 2'b01;
        end else begin
            color = 2'b00;
        end    
    end


    assign victory_condition = &visibilities;
endmodule