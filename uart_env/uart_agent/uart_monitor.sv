class uart_monitor extends uvm_monitor;
    // Register with Factory
    `uvm_component_utils(uart_monitor)
    // Declare the interface and transaction
    virtual uart_interface vif;
    uart_transaction act_trans;
    // Declare the monitor to scoreboard port
    uvm_analysis_port #(uart_transaction) mon2sb_port;
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        act_trans   =   new("act_trans");
        mon2sb_port =   new("mon2sb_port", this);
    endfunction //new()
    // build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual uart_interface)::get(this, "", "intf", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction
    // run task
    task run_phase (uvm_phase phase);
        forever begin
            collect_trans();
            mon2sb_port.write(act_trans);
        end
    endtask

    task collect_trans ();
        wait (!vif.sys_rst);
        @(vif.monitor_cb);
        act_trans.csr_do  <=  vif.monitor_cb.csr_do;
        act_trans.rx_irq  <=  vif.monitor_cb.rx_irq;
        act_trans.tx_irq  <=  vif.monitor_cb.tx_irq;
        act_trans.uart_tx <=  vif.monitor_cb.uart_tx;
        `uvm_info(get_full_name(), $sformatf("TRANSACTION FROM MONITOR"), UVM_LOW);
        act_trans.print();
    endtask
endclass //uart_monitor extends uvm_monitor#(uart_transaction)