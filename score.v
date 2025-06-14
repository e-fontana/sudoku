module score (
    input clk_50MHz,
    input finish, // Botão para finalizar o jogo
    output reg [7:0] score = 0,
    output reg [11:0] timer = 0
);
    // Lógica de pontuação
    always @(posedge clk_50MHz) begin
        if (!finish) begin
            if (timer <= 60) begin
                score <= 100;
            end else if (timer >= 1800) begin
                score <= 0;
            end else begin
                score <= 100 - (((timer - 60) * 100) / 1740);
            end
        end
    end
endmodule