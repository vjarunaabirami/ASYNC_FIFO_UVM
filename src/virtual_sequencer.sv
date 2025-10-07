class virtual_sequencer extends uvm_sequencer;
  
    `uvm_component_utils(virtual_sequencer)

    write_sequencer wr_seqr;
    read_sequencer  rd_seqr;

    function new(string name = "virtual_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction
  
endclass

