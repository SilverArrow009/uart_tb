class uart_scoreboard extends uvm_scoreboard;
    // Register with factory
    `uvm_component_utils(uart_scoreboard)
    // Declare the members of the class
    uvm_analysis_export#(uart_transaction) rm2sb_export, mon2sb_export;
    uvm_tlm_analysis_fifo#(uart_transaction) rm2sb_export_fifo, mon2sb_export_fifo;
    uart_transaction exp_trans, act_trans;
    uart_transaction exp_trans_fifo[$], act_trans_fifo[$];
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rm2sb_export         =   new("rm2sb_export", this);  
        mon2sb_export        =   new("mon2sb_export", this);  
        rm2sb_export_fifo    =   new("rm2sb_export_fifo", this);       
        mon2sb_export_fifo   =   new("mon2sb_export_fifo", this);        
    endfunction
    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        rm2sb_export.connect(rm2sb_export_fifo.analysis_export);        
        mon2sb_export.connect(mon2sb_export_fifo.analysis_export);
    endfunction
    // Run phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            mon2sb_export_fifo.get(act_trans);  // retrieve the transaction from monitor
            if (act_trans == null) $stop;
            act_trans_fifo.push_back(act_trans);    //  push into the queue. used to populate queue for later.
            rm2sb_export_fifo.get(exp_trans);  // retrieve the transaction from ref module
            if (exp_trans == null) $stop;
            exp_trans_fifo.push_back(exp_trans);    //  push into the queue. used to populate queue for later.
            compare_trans();
        end
    endtask

    task compare_trans();
        uart_transaction act_trans, exp_trans;
        if (act_trans_fifo.size != 0) begin
            act_trans = act_trans_fifo.pop_front();
        end
        if (exp_trans_fifo.size != 0) begin
            exp_trans = exp_trans_fifo.pop_front();
        end
        if (act_trans.csr_do == exp_trans.csr_do) begin
            `uvm_info(get_full_name(), $sformatf("DATA MATCHES"), UVM_LOW);
        end
        else begin
            `uvm_info(get_full_name(), $sformatf("DATA MISMATCHES"), UVM_LOW);
        end
    endtask
endclass //uart_scoreboard extends uvm_scoreboard