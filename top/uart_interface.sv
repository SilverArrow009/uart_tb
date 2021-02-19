interface uart_interface (input logic sys_clk, sys_rst);
    // Define the signals in interface
        // CSR signals
        bit [13:0]  csr_a;
        bit csr_we;
        bit [31:0]  csr_di;
        bit [31:0]  csr_do;
        // UART signals
        bit rx_irq;
        bit tx_irq;
        bit uart_rx;
        bit uart_tx;
    // Define the clocking blocks for driver and monitor
    clocking driver_cb @(posedge sys_clk);  // Drive at posedge
        // CSR signals
        output  csr_a;
        output  csr_we;
        output  csr_di;
        // UART  signals
        output  uart_rx;
    endclocking
    clocking monitor_cb @(negedge sys_clk); // Sample at negedge
        // UART  signals
        input   csr_do;
        input   rx_irq;
        input   tx_irq;
        input  uart_tx;
    endclocking
    // Define Modports for driver and monitor 
    modport DRV (clocking driver_cb, input sys_clk, sys_rst);
    modport MON (clocking monitor_cb, input sys_clk, sys_rst);
endinterface