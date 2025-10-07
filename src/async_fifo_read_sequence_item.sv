`include "uvm_macros.svh"
import uvm_pkg::*;
`include"defines.sv"

class async_fifo_read_sequence_item extends uvm_sequence_item;
  
  rand bit   rinc;
  logic   rempty;
  logic [`DSIZE-1:0]  rdata;

  
  function new(string name="");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(async_fifo_read_sequence_item)
    `uvm_field_int(rinc,UVM_ALL_ON)
    `uvm_field_int(rempty,UVM_ALL_ON)
    `uvm_field_int(rdata,UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass
