`timescale 1ns/1ps

module uart_transceiver_testbench;
    // Define the parameters and signals
    bit sys_clk, sys_rst;
    parameter period = 2;
    parameter div = 500000000/(16*9600);
    logic [15:0] divisor;
    logic uart_tx, uart_rx;
    logic tx_done, rx_done;
    logic [7:0] tx_data, rx_data;
    logic tx_wr;
    // debug ports
    // logic en16_out;
    // logic [15:0] en16_cntr_out;
    // Generate the clock
    initial begin
        sys_clk = 1'b0;
        forever #(period/2) sys_clk = ~sys_clk;
    end
    // instantiiate DUT and connect
    uart_transceiver dut_inst(
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .divisor(divisor),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx),
        .tx_done(tx_done),
        .rx_done(rx_done),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .tx_wr(tx_wr)
        // debug
        // .en16_out(en16_out),
        // .en16_cntr_out(en16_cntr_out)
    );
    // Drive the signals
    initial begin
        divisor <=  div;
        tx_data <= 8'h4A;
        tx_wr   <= 1'b1;
        sys_rst <= 1'b1;
        #2
        sys_rst <= 1'b0;
        #3
        tx_wr   <= 1'b0;
    end
endmodule