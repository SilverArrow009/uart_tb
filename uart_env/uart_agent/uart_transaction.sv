class uart_transaction extends uvm_sequence_item;
    // Define the constituents of sequence item
        // CSR signals
        bit [13:0]  csr_a = 'd0;
        rand bit csr_we; // Randomize write enable
        rand bit [31:0]  csr_di;    //Randomize input data
        bit [31:0]  csr_do;
        // UART signals
        bit rx_irq;
        bit tx_irq;
        bit uart_rx;
        bit uart_tx;
    // Register the attributes to factory using uvm macros
    `uvm_object_utils_begin(uart_transaction)
        `uvm_field_int(csr_a, UVM_DEFAULT)
        `uvm_field_int(csr_we, UVM_DEFAULT)
        `uvm_field_int(csr_di, UVM_DEFAULT)
        `uvm_field_int(csr_do, UVM_DEFAULT)
        `uvm_field_int(rx_irq, UVM_DEFAULT)
        `uvm_field_int(tx_irq, UVM_DEFAULT)
        `uvm_field_int(uart_rx, UVM_DEFAULT)
        `uvm_field_int(uart_tx, UVM_DEFAULT)
    `uvm_object_utils_end
    // Declare the Constructor
    function new(string name = "uart_transaction");
        super.new(name);
    endfunction //new()
    // Add constraints for datatypes
    constraint we_c {csr_we inside {0,1}; }
    constraint di_c {csr_di inside {[8'h00:8'hFF]}; }
endclass //uart_transaction extends uvm_sequence_item