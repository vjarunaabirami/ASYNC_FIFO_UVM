class async_fifo_write_seq extends uvm_sequence #(async_fifo_write_sequence_item);
  `uvm_object_utils(async_fifo_write_seq)

  function new(string name = "fifo_write_seq");
    super.new(name);
  endfunction

  task body();

    repeat (30) begin
      `uvm_do_with(req,{req.winc==1'b1;})

      `uvm_info("WRITE_SEQ", $sformatf("WRITE -> Data: 0x%0h", req.wdata), UVM_LOW)
      
    end
    `uvm_do_with(req,{req.winc==1'b0; req.wdata==0;})
  endtask
endclass

class write_full extends uvm_sequence #(async_fifo_write_sequence_item);
  async_fifo_write_sequence_item req;
  `uvm_object_utils(write_full)
  
  function new(string name="");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(30)
      begin
        `uvm_do_with(req,{req.winc==1'b1;})
      end
  endtask   
endclass

class no_write extends uvm_sequence #(async_fifo_write_sequence_item);
  async_fifo_write_sequence_item req;
  `uvm_object_utils(no_write)
  
  function new(string name="");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(30)
      begin
        `uvm_do_with(req,{req.winc==1'b0;})
      end
  endtask   
endclass

class wrt_dist extends uvm_sequence #(async_fifo_write_sequence_item);
  async_fifo_write_sequence_item req;
  `uvm_object_utils(wrt_dist)
  
  function new(string name="");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(30)
      begin
        `uvm_do_with(req, { req.winc dist { 1 := 80, 0 := 20 }; })
      end
  endtask
endclass

