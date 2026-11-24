`timescale 1ns/1ps

module uart_tb;

reg clk, rst, tx_start;
reg [7:0] tx_data;

wire tx, tx_busy;
wire [7:0] rx_data;
wire rx_done;

uart_tx #(.CLKS_PER_BIT(5208)) TX (
    .clk(clk), .rst(rst),
    .tx_start(tx_start), .tx_data(tx_data),
    .tx(tx), .tx_busy(tx_busy)
);

uart_rx #(.CLKS_PER_BIT(5208)) RX (
    .clk(clk), .rst(rst),
    .rx(tx), .rx_data(rx_data), .rx_done(rx_done)
);

always #10 clk = ~clk;

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);

    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 0;

    repeat(5) @(negedge clk);
    rst = 0;

    send_byte(8'hA5);
    send_byte(8'h3C);
    send_byte(8'h00);
    send_byte(8'hFF);

    $display("UART TESTING COMPLETED");
    #100;
    $finish;
end

task send_byte;
input [7:0] data;
begin
    @(negedge clk);
    tx_data = data;
    tx_start = 1;

    @(negedge clk);
    tx_start = 0;

    wait(rx_done == 1);
    #1;

    if (rx_data == data)
        $display("PASS: Sent=%h Received=%h", data, rx_data);
    else
        $display("FAIL: Sent=%h Received=%h", data, rx_data);

    wait(tx_busy == 0);
    repeat(2) @(negedge clk);
end
endtask

initial begin
    #5000000;
    $display("ERROR: Simulation timeout!");
    $finish;
end

endmodule
