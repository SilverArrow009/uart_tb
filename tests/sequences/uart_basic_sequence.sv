class uart_basic_sequence extends uvm_sequence#(uart_transaction);
    // register with the factory
    `uvm_object_utils(uart_basic_sequence)
    // Constructor
    function new(string name = "uart_basic_sequence");
        super.new(name);
    endfunction //new()
    // Body of sequencer
    virtual task body();
        for (int i=0; i<10; ++i) begin
            req =   uart_transaction::type_id::create("req");
            start_item(req);
            req.randomize();
            `uvm_info(get_full_name(), $sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE"), UVM_LOW);
            req.print();
            finish_item(req);
            get_response(rsp);  // blocking call to seq_item_port.put(rsp) in driver code. sequence will not continue untill the rsp is received
        end
    endtask
endclass //uart_basic_sequence extends uvm_sequence