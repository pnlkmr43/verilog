module uart_single_frame_tx(
    input clk,           // 100 MHz clock
    input send,          // Pulse this to start transmission
    input [7:0] data,    // Byte to send
    output reg tx,       // UART TX output
    output reg busy      // High while transmitting
);

    localparam BAUD_RATE = 9600;
    localparam CLOCK_FREQ = 100_000_000;
    localparam CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE; // 100e6 / 9600 = ~10416

    reg [13:0] clk_cnt = 0; // Count up to 10416
    reg [3:0] bit_index = 0;
    reg [9:0] frame = 10'b1111111111;
    reg sending = 0;

    always @(posedge clk) begin
	
        if (!sending && send) begin
            frame <= {1'b1, data, 1'b0}; // Stop + Data + Start
            sending <= 1;
            clk_cnt <= 0;
            bit_index <= 0;
            busy <= 1;
        end 
		
		else if (sending) begin
		
		    clk_cnt <= clk_cnt + 1;
		
            if (clk_cnt == (CLKS_PER_BIT - 1)) begin //10416
                    clk_cnt <= 0;
                    tx <= frame[bit_index];
                    bit_index <= bit_index + 1;
                    
                    if (bit_index == 9) begin
                        sending <= 0;
                        busy <= 0;
                        tx <= 1; // idle
                    end
                
            end 
   
          end
          
		else begin
            tx <= 1; // idle
        end
    end
endmodule
