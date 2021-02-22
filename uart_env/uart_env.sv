class uart_env extends uvm_env;
    // Define the components of class
    uart_agent agent;
    uart_scoreboard scoreboard;
    uart_ref_model ref_model;
    // Register with facory
    `uvm_component_utils(uart_env);
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()
    // build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent  =   uart_agent::type_id::create("uart_agent", this);        
        scoreboard =   uart_scoreboard::type_id::create("uart_scoreboard", this);        
        ref_model =   uart_ref_model::type_id::create("uart_ref_model", this);
    endfunction
    // connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.driver.drv2rm_port.connect(ref_model.drv2rm_export);
        agent.monitor.mon2sb_port.connect(scoreboard.mon2sb_export);
        ref_model.rm2sb_port.connect(scoreboard.rm2sb_export);
    endfunction
    
endclass //uart_env extends uvm_env