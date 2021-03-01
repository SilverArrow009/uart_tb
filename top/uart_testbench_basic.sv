module uart_testbench_basic;
    // Define the parameters and signals
    bit sys_clk, sys_rst;
    parameter period = 2;
    logic [13:0] csr_a ;
    logic csr_we       ;
    logic [31:0] csr_di;
    logic [31:0] csr_do;
    logic rx_irq       ;
    logic tx_irq       ;
    logic uart_rx      ;
    logic uart_tx      ;
    // Generate the clock
    initial begin
        sys_clk = 1'b0;
        sys_rst = 1'b0;
        forever #(period/2) sys_clk = ~sys_clk;
    end
    // instantiiate DUT and connect
    uart #(.csr_addr(4'h0), .clk_freq(500000000), .baud (9600)) dut_inst(
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .csr_a  (csr_a),
        .csr_we (csr_we),
        .csr_di (csr_di),
        .csr_do (csr_do),
        .rx_irq (rx_irq),
        .tx_irq (tx_irq),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx)
    );
    // Drive the signals
    initial begin
        sys_rst     <=  1'b1;   // reset sets the divisor
        csr_we      <=  'h1;    // Write enable for uart_tx. must be high one clock cycle before you want the transfer. configure the params while it is high
        csr_a       <=  14'h0002;    // Address to configure various params such as thru and divisor
        // csr_di[15:0]<=  16'h0001;// Configures divisor when csr_a is 2'b01.
        #(2*period)
        sys_rst     <=  1'b0;
        #(period)
        csr_di      <=  'h0;    // Configues thru when csr_a is 2'b10
        #(period)
        csr_a       <=  'h0;  // switch the mode back for transfer
        csr_di      <=  8'h4A;  // Data-in register (8-bit). must hold valid value before csr_we is asserted and deasserted
        #(period)
        csr_we      <=  'h0;    // Write enable for uart_tx. pull it low to start transfer.
    end
endmodule