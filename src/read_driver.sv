class read_driver extends uvm_driver #(async_fifo_read_sequence_item);
  
  `uvm_component_utils(read_driver)

  virtual async_fifo_interface vif;

  function new(string name = "async_fifo_read_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual async_fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not set for async_fifo_read_driver");
  endfunction

  task send_to_interface(async_fifo_read_sequence_item req);
    vif.read_drv_cb.rinc <= req.rinc;  
  endtask

  task drive(async_fifo_read_sequence_item req);
    
    //while (vif.rempty) @(posedge vif.read_drv_cb);
    send_to_interface(req);
    `uvm_info("READ_DRIVER", $sformatf("Reading: RINC=%0b", req.rinc), UVM_LOW)
    
    repeat(2) @(posedge vif.read_drv_cb);    
    
  endtask

  task run_phase(uvm_phase phase);
    
    repeat(3) @(posedge vif.read_drv_cb);

    forever begin
      seq_item_port.get_next_item(req); 
      drive(req);                       
      seq_item_port.item_done();        
    end
  endtask

endclass

