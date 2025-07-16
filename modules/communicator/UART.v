module UART (
	input        		clock,	// 50 MHz clock
   input        		reset,   // Reset
   input        		rx,      // UART RX do conversor USB/RS232
   output reg   		tx,      // UART TX to conversor USB/RS232
   output reg [7:0] 	rx_data, // Dado recebido
   output reg   		rx_ready,// = 1 quando dado rx_data é recebido
   input  [7:0] 		tx_data, // Dado a ser transmitido
   input        		tx_start,// = 1 para iniciar transmissão de tx_data
   output reg   		tx_busy  // = 1 durante a transmissão de tx_data
);

parameter CLK_FREQ = 50000000;      		// Frequência da DE2-115
parameter BAUD     = 115200;					// Taxa da transmissão (ajustar entre as duas partes)
localparam CLKS_PER_BIT = CLK_FREQ / BAUD;// Quantidade de pulsos de clock para cada bit

//// RX
reg [15:0] rx_clk_cnt = 0;
reg [3:0]  rx_bit_cnt = 0;
reg [7:0]  rx_shift   = 0;
reg        rx_state   = 0;

always @(posedge clock or posedge reset) 
begin
    if (reset) 
	 begin
        rx_state  <= 0;
        rx_ready  <= 0;
        rx_bit_cnt <= 0;
        rx_clk_cnt <= 0;
    end 
	 else 
	 begin
        rx_ready <= 0;

        case (rx_state)
            0: begin // IDLE
                if (~rx) 
					 begin // START BIT detectado
                    rx_state <= 1;
                    rx_clk_cnt <= CLKS_PER_BIT/2; // amostragem feita no meio do intervalo
                    rx_bit_cnt <= 0;
                end
            end
            1: begin // recebendo os bits
                if (rx_clk_cnt == CLKS_PER_BIT-1) 
					 begin
                    rx_clk_cnt <= 0;
                    rx_shift <= {rx, rx_shift[7:1]};
                    rx_bit_cnt <= rx_bit_cnt + 1;
                    if (rx_bit_cnt == 7) 
						  begin
                        rx_state <= 2;
                    end
                end 
					 else 
					 begin
                    rx_clk_cnt <= rx_clk_cnt + 1;
                end
            end
            2: begin
                rx_ready <= 1;
                rx_data  <= rx_shift;
                rx_state <= 0;
            end
        endcase
    end
end

//// TX
reg [15:0] tx_clk_cnt = 0;
reg [3:0]  tx_bit_cnt = 0;
reg [9:0]  tx_shift   = 10'b1111111111;

always @(posedge clock or posedge reset) 
begin
    if (reset) 
	 begin
        tx <= 1;
        tx_busy <= 0;
        tx_bit_cnt <= 0;
        tx_clk_cnt <= 0;
    end 
	 else 
	 begin
        if (tx_start && !tx_busy) 
		  begin
            tx_shift <= {1'b1, tx_data, 1'b0}; // FRAME = STOP BIT <- dado <- START BIT
            tx_busy  <= 1;
            tx_bit_cnt <= 0;
            tx_clk_cnt <= 0;
        end 
		  else 
		  if (tx_busy) 
		  begin
            if (tx_clk_cnt == CLKS_PER_BIT - 1) 
				begin
                tx_clk_cnt <= 0;
                tx <= tx_shift[0];
                tx_shift <= {1'b1, tx_shift[9:1]};
                tx_bit_cnt <= tx_bit_cnt + 1;
                if (tx_bit_cnt == 9) 
					 begin
                    tx_busy <= 0;
                    tx <= 1;
                end
            end 
				else 
				begin
                tx_clk_cnt <= tx_clk_cnt + 1;
            end
        end
    end
end

endmodule
