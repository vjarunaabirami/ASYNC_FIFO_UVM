class read_sequencer extends uvm_sequencer #(async_fifo_read_sequence_item);
  
  `uvm_component_utils(read_sequencer)
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
