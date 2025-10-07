class write_agent extends uvm_agent;
  
  write_sequencer seqr;  
  write_driver 	  drv;
  write_monitor   mon;
  
  `uvm_component_utils(write_agent)
  
  function new(string name = "write_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE) 
      begin
        drv.seq_item_port.connect(seqr.seq_item_export);
      end
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE)
      begin
        drv  = write_driver::type_id::create("drv",this);
        seqr = write_sequencer::type_id::create("seqr",this);
      end  
    mon = write_monitor::type_id::create("mon",this);
  endfunction
endclass
  
  
  
  
  
