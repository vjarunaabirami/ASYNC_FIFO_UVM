class write_monitor extends uvm_monitor;

  `uvm_component_utils(write_monitor)
  
  virtual async_fifo_interface.WRITE_MON_MP vif;

  async_fifo_write_sequence_item seq_item;

  uvm_analysis_port#(async_fifo_write_sequence_item) write_port;

  function new(string name = "write_monitor", uvm_component parent = null);
    super.new(name, parent);
    write_port = new("write_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual async_fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction
  
  task monitor();
    seq_item = async_fifo_write_sequence_item::type_id::create("seq_item", this);

    //repeat(1) @(posedge vif.mon_cb);

    seq_item.wdata = vif.write_mon_cb.wdata;
    seq_item.winc  = vif.write_mon_cb.winc;
    seq_item.wfull = vif.write_mon_cb.wfull;

    `uvm_info("WRITE_MONITOR", $sformatf("Observed Write: DATA=0x%0h, WINC=%0b, WFULL=%0b", seq_item.wdata, seq_item.winc, seq_item.wfull), UVM_LOW)

    write_port.write(seq_item);

    repeat(2) @(posedge vif.write_mon_cb);
  endtask

  task run_phase(uvm_phase phase);   
    repeat(5) @(posedge vif.write_mon_cb);
    forever begin
      monitor();
    end
  endtask

endclass

