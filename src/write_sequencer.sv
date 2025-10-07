class write_sequencer extends uvm_sequencer #(async_fifo_write_sequence_item);
  
  `uvm_component_utils(write_sequencer)

  function new(string name = "write_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass

