class uart_agent extends uvm_agent;
    // Instantiate the members of the class
    uart_driver driver;
    uart_sequencer sequencer;
    uart_monitor monitor;
    // Register with factory
    `uvm_component_utils(uart_agent)
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()
    // Build phase
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        driver      =   uart_driver::type_id::create("driver", this);
        monitor     =   uart_monitor::type_id::create("monitor", this);
        sequencer   =   uart_sequencer::type_id::create("sequencer", this);   
    endfunction
    // Connect phase
    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass //uart_agent extends uvm_agent