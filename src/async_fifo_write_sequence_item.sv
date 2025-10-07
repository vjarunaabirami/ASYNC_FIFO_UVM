`include "uvm_macros.svh"
 import uvm_pkg::*;
`include"defines.sv"

class async_fifo_write_sequence_item extends uvm_sequence_item;
  
  rand bit [`DSIZE-1:0]  wdata;
  rand bit winc;  
  logic  wfull;
   
  function new(string name="");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(async_fifo_write_sequence_item)
    `uvm_field_int(wdata,UVM_ALL_ON)
    `uvm_field_int(winc,UVM_ALL_ON)
    `uvm_field_int(wfull,UVM_ALL_ON)
  `uvm_object_utils_end
endclass
