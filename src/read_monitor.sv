class read_monitor extends uvm_monitor;

  `uvm_component_utils(read_monitor)

  virtual async_fifo_interface.READ_MON_MP vif;

  async_fifo_read_sequence_item seq_item;

  uvm_analysis_port#(async_fifo_read_sequence_item) read_port;

  function new(string name = "read_monitor", uvm_component parent = null);
    super.new(name, parent);
    read_port = new("read_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual async_fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  task monitor();
    
    seq_item = async_fifo_read_sequence_item::type_id::create("seq_item", this);

    //repeat(1) @(posedge vif.mon_cb);

    seq_item.rinc   = vif.read_mon_cb.rinc;
    seq_item.rempty = vif.read_mon_cb.rempty;
    seq_item.rdata  = vif.read_mon_cb.rdata; 

    `uvm_info("READ_MONITOR", $sformatf("Observed Read: RINC=%0b, REMPTY=%0b, DATA=0x%0h",seq_item.rinc, seq_item.rempty, seq_item.rdata), UVM_LOW)

    read_port.write(seq_item);

    repeat(2) @(posedge vif.read_mon_cb);
  endtask

  task run_phase(uvm_phase phase);
    repeat(5) @(posedge vif.read_mon_cb);

    forever begin
      monitor();
    end
  endtask

endclass

