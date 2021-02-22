class uart_basic_test extends uvm_test;
    // Register with factory
    `uvm_component_utils(uart_basic_test)
    // Declare the components required for test
    uart_basic_sequence seq;
    uart_env env;
    // Define constructor
    function new(string name = "uart_basic_test", uvm_component parent);
        super.new(name, parent);
    endfunction //new()
    // build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env =   uart_env::type_id::create("env", this);
        seq =   uart_basic_sequence::type_id::create("uart_basic_sequence", this);
    endfunction
    // Run phase
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
            seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass //uart_basic_test extends uvm_test