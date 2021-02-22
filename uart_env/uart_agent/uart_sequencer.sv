class uart_sequencer extends uvm_sequencer #(uart_transaction);
    // Register with factory
    `uvm_component_utils(uart_sequencer)
    // Define a constructor
    function new(string name, uvm_component parent);
       super.new(name, parent); 
    endfunction //new()
endclass //uart_sequencer extends uvm_sequencer