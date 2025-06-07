module top_uart_send_once(
    input clk,       // 100 MHz
    output tx_out    // Output pin mapped to JA1
);
    wire busy;
    reg send = 0;
    reg [7:0] data = 8'h41; // ASCII 'A'

    reg [31:0] counter = 0;
    reg trigger = 0;

    // Instantiate UART TX
    uart_single_frame_tx uart_tx (
        .clk(clk),
        .send(trigger),
        .data(data),
        .tx(tx_out),
        .busy(busy)
    );


    // Generate single send pulse after some delay (simulate button press)
    always @(posedge clk) begin
        counter <= counter + 1;
        
        if (counter == 100000000) begin // after 1 sec
            counter <= 0;
            trigger <= 1;
        end else begin
            trigger <= 0;
        end
        
    end
endmodule
