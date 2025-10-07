class async_fifo_read_seq extends uvm_sequence #(async_fifo_read_sequence_item);
  `uvm_object_utils(async_fifo_read_seq)

  function new(string name = "async_fifo_read_seq");
    super.new(name);
  endfunction

  task body();
    
    repeat(30) begin
      `uvm_do_with(req,{req.rinc==1'b1;})
      
      `uvm_info("READ_SEQ", $sformatf("Read sequence generated: %s", req.convert2string()), UVM_LOW)
      
    end
  endtask
endclass

class no_read extends uvm_sequence #(async_fifo_read_sequence_item);
  async_fifo_read_sequence_item req;
  `uvm_object_utils(no_read)
  
  function new(string name="");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(30)
      begin
        `uvm_do_with(req,{req.rinc==1'b0;})
      end
  endtask
endclass

class full_read extends uvm_sequence #(async_fifo_read_sequence_item);
  async_fifo_read_sequence_item req;
  `uvm_object_utils(full_read)
  
  function new(string name="");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(30)
      begin
        `uvm_do_with(req,{req.rinc==1'b1;})
      end
  endtask
endclass
  

class rd_dist extends uvm_sequence #(async_fifo_read_sequence_item);
  async_fifo_read_sequence_item req;
  `uvm_object_utils(rd_dist)
  
  function new(string name="");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(30)
      begin
        `uvm_do_with(req, { req.rinc dist { 1 := 40, 0 := 60 }; })
      end
  endtask
endclass
