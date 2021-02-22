class uart_driver extends uvm_driver #(uart_transaction);
    // Define a sequence item to drive
        uart_transaction trans;
    // Define the interface as virtual member of the class
        virtual uart_interface vif;
    // Add a port to communicate with ref_module
        uvm_analysis_port #(uart_transaction) drv2rm_port;
    // register with the factory
        `uvm_component_utils(uart_driver)
    // Define the constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()
    // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual uart_interface)::get(this, "", "intf", vif)) begin
                `uvm_fatal("NO_VIF", {"virtual interface must be sef for ", get_full_name(), ".vif"});
            end
            drv2rm_port     =   new("drv2rm_port", this);
        endfunction : build_phase
    // Run task
        task run_phase(uvm_phase phase);
           reset(); // Reset all the signals. This is a custom task
           forever begin
               seq_item_port.get_next_item(req); // This is a inbuilt port. A part of driver class.
               drive();
               `uvm_info(get_full_name(), $sformatf("TRANSACTION FROM DRIVER"), UVM_LOW);
               req.print();
               @(vif.driver_cb);
                $cast(rsp, req.clone()); // create a clone of req as rsp
                rsp.set_id_info(req);    // copy the sequence and transaction id from the original seq_item "req"
                drv2rm_port.write(rsp);  // write the transaction to ref_module
                seq_item_port.item_done();   // Done response to sequencer
                seq_item_port.put(rsp);  // write acknowledgement to sequencer
           end
        endtask

        task reset();
            vif.driver_cb.csr_a   <= 'h0;
            vif.driver_cb.csr_we  <= 'h0;
            vif.driver_cb.csr_di  <= 'h0;
            vif.driver_cb.uart_rx <= 'h0;
        endtask

        task drive();
            wait (!vif.sys_rst);
            @(vif.driver_cb);
                vif.driver_cb.csr_a   <= req.csr_a;
                vif.driver_cb.csr_we  <= req.csr_we;
                vif.driver_cb.csr_di  <= req.csr_di;
                vif.driver_cb.uart_rx <= req.uart_rx;        
        endtask
endclass //uart_driver extends uvm_driver #(uart_transaction)