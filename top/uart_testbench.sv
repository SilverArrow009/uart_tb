import uvm_pkg::*;
import uart_testlist_pkg::*;


module uart_testbench;
    // Define the parameters and signals
    bit sys_clk, sys_rst;
    parameter period = 10;
    wire [13:0] csr_a ;
    wire csr_we       ;
    wire [31:0] csr_di;
    wire [31:0] csr_do;
    wire rx_irq       ;
    wire tx_irq       ;
    wire uart_rx      ;
    wire uart_tx      ;
    // Generate the clock
    initial begin
        sys_clk = 1'b0;
        sys_rst = 1'b0;
        forever #(period/2) sys_clk = ~sys_clk;
    end
    // declare the interface
    uart_interface intf(sys_clk, sys_rst);
    // declare the local signals (or xsim to work)
    assign csr_a      =   intf.csr_a;
    assign csr_we     =   intf.csr_we;
    assign csr_di     =   intf.csr_di;
    assign csr_do     =   intf.csr_do;
    assign rx_irq     =   intf.rx_irq;
    assign tx_irq     =   intf.tx_irq;
    assign uart_rx    =   intf.uart_rx;
    assign uart_tx    =   intf.uart_tx;
    // instantiiate DUT and connect
    uart dut_inst(
        .sys_clk(sys_clk),
        .sys_rst(sys_clk),
        .csr_a  (csr_a),
        .csr_we (csr_we),
        .csr_di (csr_di),
        .csr_do (csr_do),
        .rx_irq (rx_irq),
        .tx_irq (tx_irq),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx)
    );
    // Pass the handle of physical interface "intf" to virtual interfaces "vif" in driver and monitor
    initial begin
        uvm_config_db#(virtual uart_interface)::set(uvm_root::get(),"*","intf",intf);        
    end
    // Run the test
    initial begin
        run_test("uart_basic_test"); // Give test names as args
    end
endmodule

