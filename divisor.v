module divisor(
    input clk_50MHz,
    output clk_1Hz
);
    // Divisor de clk: 50MHz ---> 1Hz
    reg [25:0] counter = 0;
    wire clk_1Hz = (counter == 49_999_999); 

    always @(posedge clk_50MHz) begin
        if (counter == 49_999_999) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    // Cronômetro de 0 a 30min(1800 segundos)
    always @(posedge clk_50MHz) begin
        if (clk_1Hz) begin
            if (timer == 1800) begin
                timer <= 0;  // Reseta o cronômetro após 30 minutos
            end else begin
                timer <= timer + 1;
            end
        end 
    end
endmodule