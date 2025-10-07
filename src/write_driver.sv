class write_driver extends uvm_driver #(async_fifo_write_sequence_item);
  `uvm_component_utils(write_driver)

  virtual async_fifo_interface vif;  

  function new(string name = "async_fifo_write_driver_simplified", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual async_fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not set for async_fifo_write_driver_simplified");
  endfunction

  task send_to_interface();
    vif.write_drv_cb.wdata <= req.wdata;
    vif.write_drv_cb.winc  <= req.winc;
  endtask

  task drive(async_fifo_write_sequence_item req);
    
    //while (vif.wfull) @(posedge vif.write_drv_cb); 
    send_to_interface();
    `uvm_info("WRITE_DRIVER", $sformatf("Driving: DATA=0x%0h, WINC=%0b", req.wdata, req.winc), UVM_LOW)
    
    repeat(2) @(posedge vif.write_drv_cb);
    
  endtask

  task run_phase(uvm_phase phase);
    repeat(3) @(posedge vif.write_drv_cb);

    forever begin
      seq_item_port.get_next_item(req);  
      drive(req);                        
      seq_item_port.item_done();   
    end
  endtask

endclass

