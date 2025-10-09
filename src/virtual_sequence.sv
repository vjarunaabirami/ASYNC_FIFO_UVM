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

  // NEW: select which sequence to run
  string run_seq_name;

  function new(string name = "virtual_sequence");
    super.new(name);
    run_seq_name = "write_read"; // default
  endfunction

  `uvm_declare_p_sequencer(virtual_sequencer)

  task body();

    w_seq = async_fifo_write_seq::type_id::create("w_seq");
    full_wrt_seq= write_full::type_id::create("full_wrt_seq");
    no_wrt_seq  = no_write::type_id::create("no_wrt_seq");
    wdist_seq   = wrt_dist::type_id::create("wdist_seq");

    r_seq = async_fifo_read_seq::type_id::create("r_seq");
    no_rd_seq   = no_read::type_id::create("no_rd_seq");
    full_rd_seq = full_read::type_id::create("full_rd_seq");
    rdist_seq   = rd_dist::type_id::create("rd_dist");

    case (run_seq_name)
      "write_read": begin
          w_seq.start(p_sequencer.wr_seqr);
          #100; // wait for some writes before reading
          r_seq.start(p_sequencer.rd_seqr);
      end
      "read_write": begin
          r_seq.start(p_sequencer.rd_seqr);
          #100;
          w_seq.start(p_sequencer.wr_seqr);
      end
      "no_write": no_wrt_seq.start(p_sequencer.wr_seqr);
      "no_read": no_rd_seq.start(p_sequencer.rd_seqr);
      "full_write": full_wrt_seq.start(p_sequencer.wr_seqr);
      "full_read": full_rd_seq.start(p_sequencer.rd_seqr);
      "write_dist": wdist_seq.start(p_sequencer.wr_seqr);
      "read_dist": rdist_seq.start(p_sequencer.rd_seqr);
      default: begin
        `uvm_error(get_full_name(), "Unknown sequence name")
      end
    endcase

  endtask
endclass

