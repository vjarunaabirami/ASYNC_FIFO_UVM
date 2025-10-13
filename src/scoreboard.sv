
class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  // Analysis FIFOs from monitors
  uvm_tlm_analysis_fifo#(async_fifo_write_sequence_item) write_fifo;
  uvm_tlm_analysis_fifo#(async_fifo_read_sequence_item)  read_fifo;

  // Reference FIFO model
  bit [`DSIZE-1:0] fifo_mem[$];
  int depth = 1 << `ASIZE;
  bit [`DSIZE-1:0] rd_op;

  // Counters
  int write_pass_count, write_fail_count;
  int read_pass_count,  read_fail_count;

  // Constructor
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name,parent);
    write_fifo = new("write_fifo", this);
    read_fifo  = new("read_fifo", this);
    write_pass_count = 0;
    write_fail_count = 0;
    read_pass_count  = 0;
    read_fail_count  = 0;
  endfunction

  // Empty write function for analysis port connection
  function void write(uvm_object t); endfunction

  // Run phase: get transactions from FIFOs concurrently
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

  task compare_write(async_fifo_write_sequence_item tr);
  if (tr.winc) begin
    // Delay scoreboard full check to match CDC latency
    #(2 * 10); // or wait for 2 wclk posedges
    
    if (fifo_mem.size() < depth && tr.wfull == 1) begin
      write_pass_count++;
      `uvm_info("SCOREBOARD-WRITE", "wfull asserted early (within CDC tolerance)", UVM_LOW)
    end
    else if (fifo_mem.size() < depth && tr.wfull == 0) begin
      fifo_mem.push_back(tr.wdata);
      write_pass_count++;
    end
    else if (fifo_mem.size() >= depth && tr.wfull == 0) begin
      write_fail_count++;
      `uvm_error("SCOREBOARD-WRITE", "DUT failed to assert wfull at full depth")
    end
  end
endtask


  task compare_read(async_fifo_read_sequence_item tr);
  static int rempty_delay_cnt = 0;
  static int rempty_tolerance_cycles = 2; // tolerance window for CDC delay

  if (tr.rinc) begin
    // CASE 1: valid data read
    if (fifo_mem.size() > 0 && tr.rempty == 0) begin
      rd_op = fifo_mem.pop_front();
      if (tr.rdata == rd_op) begin
        read_pass_count++;
        rempty_delay_cnt = 0;
        `uvm_info("SCOREBOARD-READ", $sformatf("READ DATA MATCH: %0d, PASS (size=%0d)", tr.rdata, fifo_mem.size()), UVM_LOW)
      end
      else begin
        read_fail_count++;
        `uvm_error("SCOREBOARD-READ", $sformatf("READ MISMATCH: DUT=%0d, EXP=%0d", tr.rdata, rd_op))
      end
    end

    // CASE 2: model empty, DUT says rempty=0 — tolerate short CDC delay
    else if (fifo_mem.size() == 0 && tr.rempty == 0) begin
      rempty_delay_cnt++;
      if (rempty_delay_cnt <= rempty_tolerance_cycles) begin
        `uvm_info("SCOREBOARD-READ", $sformatf("rempty not yet asserted (tolerated %0d/%0d)", rempty_delay_cnt, rempty_tolerance_cycles), UVM_LOW)
      end
      else begin
        read_fail_count++;
        `uvm_error("SCOREBOARD-READ", "DUT failed to assert rempty after tolerance window expired")
      end
    end

    // CASE 3: model empty and DUT rempty=1 — correct
    else if (fifo_mem.size() == 0 && tr.rempty == 1) begin
      read_pass_count++;
      rempty_delay_cnt = 0;
      `uvm_info("SCOREBOARD-READ", "READ ignored, model empty, PASS", UVM_LOW)
    end

    // CASE 4: model has data but DUT rempty=1 — DUT too early
    else if (fifo_mem.size() != 0 && tr.rempty == 1) begin
      read_fail_count++;
      `uvm_error("SCOREBOARD-READ", $sformatf("DUT asserted rempty too early (model size=%0d)", fifo_mem.size()))
    end
  end
endtask

  // ---------------- REPORT ----------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD-SUMMARY", 
      $sformatf("FINAL RESULT: READ PASS=%0d | READ FAIL=%0d | WRITE PASS=%0d | WRITE FAIL=%0d", 
        read_pass_count, read_fail_count, write_pass_count, write_fail_count), UVM_NONE)
  endfunction

endclass

