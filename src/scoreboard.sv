
class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo#(async_fifo_write_sequence_item) write_fifo;
  uvm_tlm_analysis_fifo#(async_fifo_read_sequence_item)  read_fifo;

  bit [`DSIZE-1:0] fifo_mem[$];
  int depth = 1 << `ASIZE-1;
  bit [`DSIZE-1:0] read_op;

  int write_pass_count, write_fail_count;
  int read_pass_count,  read_fail_count;

  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name,parent);
    write_fifo = new("write_fifo", this);
    read_fifo  = new("read_fifo", this);
    write_pass_count = 0;
    write_fail_count = 0;
    read_pass_count  = 0;
    read_fail_count  = 0;
  endfunction

  function void write(uvm_object t); 
  endfunction

  task run_phase(uvm_phase phase);
    async_fifo_write_sequence_item write_tr;
    async_fifo_read_sequence_item  read_tr;
    super.run_phase(phase);

    forever begin
      fork
        begin
          write_fifo.get(write_tr);
          compare_write(write_tr);
        end
        begin
          read_fifo.get(read_tr);
          compare_read(read_tr);
        end
      join_any
    end
  endtask

  task compare_write(async_fifo_write_sequence_item w_tr);
    if (w_tr.winc) begin
      if (fifo_mem.size() < depth && w_tr.wfull == 0) begin
        fifo_mem.push_back(w_tr.wdata);
        write_pass_count++;
        `uvm_info("SCOREBOARD-WRITE", $sformatf("WRITE %0d COMPLETED, PASS (size=%0d)", w_tr.wdata, fifo_mem.size()), UVM_LOW)
      end
      else if (fifo_mem.size() == depth && w_tr.wfull == 1) begin
        write_pass_count++;
        `uvm_info("SCOREBOARD-WRITE", $sformatf("WRITE ignored, model full (size=%0d), PASS", fifo_mem.size()), UVM_LOW)
      end
      else begin
        write_fail_count++;
        `uvm_error("SCOREBOARD-WRITE", "DUT asserted wfull  wrong, FAIL")
      end
    end
  endtask

  task compare_read(async_fifo_read_sequence_item tr);
    if (tr.rinc) begin
      if (fifo_mem.size() > 0 && tr.rempty == 0) begin
        read_op = fifo_mem.pop_front();
        if (tr.rdata == read_op) begin
          read_pass_count++;
          `uvm_info("SCOREBOARD-READ", $sformatf("READ DATA MATCH: %0d, PASS", tr.rdata), UVM_LOW)
        end
        else begin
          read_fail_count++;
          `uvm_error("SCOREBOARD-READ", $sformatf("READ MISMATCH: DUT=%0d, EXP=%0d", tr.rdata, read_op))
        end
      end
      else if (fifo_mem.size() != 0 && tr.rempty == 1) begin
        read_fail_count++;
        read_op = fifo_mem.pop_front();
        `uvm_error("SCOREBOARD-READ", $sformatf("DUT asserted rempty too early (size=%0d), FAIL", fifo_mem.size()))
      end
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD-SUMMARY", 
      $sformatf("FINAL RESULT: READ PASS=%0d | READ FAIL=%0d | WRITE PASS=%0d | WRITE FAIL=%0d", 
        read_pass_count, read_fail_count, write_pass_count, write_fail_count), UVM_NONE)
  endfunction

endclass

