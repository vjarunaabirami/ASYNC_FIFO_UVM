class read_agent extends uvm_agent;
  
  read_monitor 	 mon;
  read_driver 	 drv;
  read_sequencer seqr;
  
  `uvm_component_utils(read_agent)
  
  function new(string name = "",uvm_component parent);
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
        drv  = read_driver::type_id::create("drv",this);
        seqr = read_sequencer::type_id::create("seqr",this);
      end  
    mon = read_monitor::type_id::create("mon",this);
  endfunction
endclass
  
  
  
  
  
