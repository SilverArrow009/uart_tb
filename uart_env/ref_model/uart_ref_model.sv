class uart_ref_model extends uvm_component;
    // Define the members of the class
        uvm_analysis_export #(uart_transaction)  drv2rm_export;
        uvm_analysis_port #(uart_transaction)   rm2sb_port;
        uart_transaction rm_trans, exp_trans;
        uvm_tlm_analysis_fifo #(uart_transaction) drv2rm_export_fifo;
    // Register to factory
    `uvm_component_utils(uart_ref_model)
    // Define the constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv2rm_export       =   new("drv2rm_export", this);
        rm2sb_port          =   new("rm2sb_port", this);
        drv2rm_export_fifo  =   new("drv2rm_export_fifo", this);
    endfunction
    // Connect phase
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        drv2rm_export.connect(drv2rm_export_fifo.analysis_export);
    endfunction : connect_phase
    // Run phase
    task run_phase(uvm_phase phase);
        forever begin
            drv2rm_export_fifo.get(rm_trans);
            get_expected_trans(rm_trans);
        end
    endtask

    task get_expected_trans(uart_transaction rm_trans);
        this.exp_trans  =   rm_trans;
        `uvm_info(get_full_name(), $sformatf("Expected transaction from ref model"), UVM_LOW);
        exp_trans.csr_do = exp_trans.csr_di;
        exp_trans.print();
        rm2sb_port.write(exp_trans);
    endtask
endclass //ref_module extends uvm_component