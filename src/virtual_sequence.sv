class virtual_sequence extends uvm_sequence_base;
  
  `uvm_object_utils(virtual_sequence)

  write_sequencer wr_seqr;
  read_sequencer  rd_seqr;
  virtual_sequencer v_seqr;
  
  async_fifo_write_seq w_seq;  
  write_full   full_wrt_seq;
  no_write     no_wrt_seq;
  wrt_dist     wdist_seq;
  
  async_fifo_read_seq  r_seq;
  no_read      no_rd_seq;
  full_read    full_rd_seq;
  rd_dist      rdist_seq;

  function new(string name = "virtual_sequence");
    super.new(name);
  endfunction

  task body();
    
   if(!$cast(v_seqr,m_sequencer))
        `uvm_error(get_full_name(),"Cast failed")
       
    w_seq = async_fifo_write_seq::type_id::create("w_seq");
    full_wrt_seq= write_full::type_id::create("full_wrt_seq"); 
    no_wrt_seq  = no_write::type_id::create("no_wrt_seq"); 
    wdist_seq   = wrt_dist::type_id::create("wdist_seq"); 
    
    r_seq = async_fifo_read_seq::type_id::create("r_seq");
    no_rd_seq   = no_read::type_id::create("no_rd_seq"); 
    full_rd_seq = full_read::type_id::create("full_rd_seq"); 
    rdist_seq   = rd_dist::type_id::create("rdist_seq"); 

    fork
      w_seq.start(v_seqr.wr_seqr); 
      r_seq.start(v_seqr.rd_seqr); 
    join
    
    // ------no read only write-----
      fork
        begin
          full_wrt_seq.start(v_seqr.wr_seqr);
        end
        begin
          no_rd_seq.start(v_seqr.rd_seqr);
          #100;
        end
      join
      
      // ------no write only read------
      fork
        begin
          no_wrt_seq.start(v_seqr.wr_seqr);
          #100;
        end
        begin
          full_rd_seq.start(v_seqr.rd_seqr);
        end
      join
      
      //  ---------random---------
      fork
        begin
          rdist_seq.start(v_seqr.rd_seqr);
        end
        begin
          wdist_seq.start(v_seqr.wr_seqr);
          #100;
        end
      join
    
  endtask
endclass

