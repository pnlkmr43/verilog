module uart_rx(
    input clk,            // 100 MHz clock
    input rx,             // UART RX input
    output reg [7:0] data,// Received data byte
    output reg valid      // Goes high for 1 clock cycle when byte received
);
    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 9600;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    localparam IDLE      = 0;
    localparam START_BIT = 1;
    localparam DATA_BITS = 2;
    localparam STOP_BIT  = 3;
    localparam CLEANUP   = 4;

    reg [2:0] state = IDLE;
    reg [13:0] clk_cnt = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] rx_shift = 0;

    always @(posedge clk) begin
	
        case (state)
				
            IDLE: begin
                valid <= 0;
                if (rx == 0) begin  // Detected start bit
                    clk_cnt <= 0;
                    state <= START_BIT;
                end
            end
			
			
            START_BIT: begin
			
                if (clk_cnt == CLKS_PER_BIT/2) begin // middle of start bit
                    if (rx == 0) begin
                        clk_cnt <= 0;
                        bit_index <= 0;
                        state <= DATA_BITS;
                    end 
					
					else begin
                        state <= IDLE; // false start
                    end
                end 
				
				
				else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end
			
			
            DATA_BITS: begin
                if (clk_cnt < CLKS_PER_BIT - 1) begin
                    clk_cnt <= clk_cnt + 1;
                end 
				
				else begin
                    clk_cnt <= 0;
                    rx_shift[bit_index] <= rx;
                    if (bit_index < 7)
                        bit_index <= bit_index + 1;
                    else
                        state <= STOP_BIT;
                end
            end
			
			
            STOP_BIT: begin
                if (clk_cnt < CLKS_PER_BIT - 1) begin
                    clk_cnt <= clk_cnt + 1;
                end 
				
				else begin
                    state <= CLEANUP;
                    clk_cnt <= 0;
                end
            end
			
			
            CLEANUP: begin
                data <= rx_shift;
                valid <= 1;
                state <= IDLE;
            end
        endcase
    end
endmodule
